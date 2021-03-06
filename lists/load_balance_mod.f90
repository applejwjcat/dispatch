!===============================================================================
!> Keep track of neighbor ranks and their loads, by sending and receiving short
!> messages, storing the info in a linked list
!>
!> When nbor lists are generated by init_all_nbors, an nbor_info_t data type
!> is added for each neighbor rank.  Part of the data type is a mesg_t data type
!> with a buffer for receiving load balance messages from neighbor ranks.  THe
!> first receive request is issued when the data type is first allocated.  The
!> nbor_info_list%recv procedure checks the list for completed messages,
!> unpack them, and issues new receive requests.
!>
!> With respect to critical regions:  The nbor_info list is essentially static,
!> except it can change if a new boundary patch is added, which has a neighbor
!> rank that was not on the list before.  If load balancing is handled by one
!> patch at a time, inside a critical region, then no other critical regaion
!> shouls be needed.
!===============================================================================
MODULE load_balance_mod
  USE io_mod
  USE trace_mod
  USE mpi_mod
  USE mpi_mesg_mod
  USE omp_timer_mod
  USE omp_lock_mod
  USE task_mod
  USE patch_mod
  USE list_mod
  USE link_mod
  USE bits_mod
  USE random_mod
  implicit none
  private
  type:: rank_info_t
    logical:: ok
    integer:: rank
    integer:: nq
    integer:: n_swap
    real:: cadence, patch_cost
    real(8):: cost=0.0
    real(8):: time, wall, dtime
    real(8):: otime, owall
    type(rank_info_t), pointer:: next => null()
    class(mesg_t), pointer:: mesg
    type(lock_t):: lock
  contains
    procedure:: imbalance
    procedure:: measure_load
  end type
  integer, save:: n_io_rank_info = (4*4 + 6*8)/4
  type:: io_rank_info_t
    sequence
    logical:: ok
    integer:: rank
    integer:: nq
    integer:: n_swap
    real(8):: cost=0.0
    real(8):: time, wall, dtime
    real(8):: otime, owall
  end type
  type:: rank_info_list_t
    type(rank_info_t), pointer:: head => null()
    type(rank_info_t), pointer:: tail => null()
    integer:: n=0
    type(lock_t):: lock
  contains
    procedure:: append
    procedure:: remove
    procedure:: send
    procedure:: recv
    procedure:: find
  end type
  type(rank_info_t):: rank_info
  type(rank_info_list_t):: rank_info_list
  !
  logical, save:: only_initial=.false.
  real, save:: cadence=1., threshold=10., grace=0.3, duration=0.0
  real, save:: next_info
  integer, save:: excess=0
  real:: q_min=10., q_max=40.
  !
  type, public:: load_balance_t
    logical:: on=.false.
    type(random_t):: random
    type(lock_t):: lock
  contains
    procedure:: init
    procedure:: active
    procedure:: add
    procedure:: pack
    procedure:: unpack
    procedure:: check_load
    procedure:: print => print_lb
  end type
  type(load_balance_t), public:: load_balance
  type(mesg_list_t):: nbor_sent_list
CONTAINS

!===============================================================================
!===============================================================================
SUBROUTINE init (self)
  class(load_balance_t):: self
  logical, save:: on=.false.
#ifndef _CRAYFTN
  type(io_rank_info_t):: io_rank_info
#endif
  namelist /load_balance_params/ on, cadence, threshold, grace, &
    duration, only_initial, q_min, q_max
  integer:: iostat
  !.............................................................................
  call self%lock%init ('load')
  rewind (io%input)
  read(io%input, load_balance_params, iostat=iostat)
  write (io%output, load_balance_params)
  self%on = on
  next_info = cadence
#ifndef _CRAYFTN
  if (n_io_rank_info*4 /= storage_size(io_rank_info)/8) then
    print *, n_io_rank_info*4, storage_size(io_rank_info)/8
    error stop 'The hardwired loadbalance_mod::n_io_rank_info is incorrect'
  end if
  n_io_rank_info = storage_size(io_rank_info)/32
#endif
END SUBROUTINE init

!===============================================================================
!===============================================================================
SUBROUTINE active (self, flag)
  class(load_balance_t):: self
  logical:: flag
  !$omp atomic write
  self%on = flag
END SUBROUTINE active

!===============================================================================
!> Pack the rank_info into an mpi_mesg_t data type
!===============================================================================
SUBROUTINE pack (self, info, mesg)
  class(load_balance_t):: self
  type(rank_info_t):: info
  class(mesg_t), pointer:: mesg
  type(io_rank_info_t):: io_rank_info
  integer:: n
  !.............................................................................
  call trace%begin ('rank_info%pack')
  n = n_io_rank_info
  allocate (mesg)
  allocate (mesg%buffer(n))
  allocate (mesg%reqs(rank_info_list%n))
  mesg%id = 1
  mesg%nbuf = n
  io_rank_info%ok    = info%ok
  io_rank_info%rank  = info%rank
  io_rank_info%cost  = info%cost
  io_rank_info%nq    = info%nq
  io_rank_info%n_swap= info%n_swap
  io_rank_info%time  = info%time
  io_rank_info%otime = info%otime
  io_rank_info%dtime = info%dtime
  io_rank_info%wall  = info%wall
  io_rank_info%owall = info%owall
  call anonymous_copy (n, io_rank_info, mesg%buffer)
  if (io%verbose>0) then
    write (io_unit%log,'(a,i6,1p,g12.3,2i6,g16.6)') 'rank_info_mod::pack rank,cost,nq,n,time =', &
       info%rank, info%cost, info%nq, n, info%time
    flush (io_unit%log)
  end if
  write (io_unit%log,*) 'send buffer =', mesg%buffer(1:5)
  call trace%end()
END SUBROUTINE pack

!===============================================================================
!> Unpack an mpi_mesg into a rank_info data type
!===============================================================================
SUBROUTINE unpack (self, buffer)
  class(load_balance_t):: self
  integer, dimension(:), pointer:: buffer
  class(rank_info_t), pointer:: nbor_info
  type(io_rank_info_t):: io_rank_info
  integer:: n
  real(8):: wc
  !.............................................................................
  call trace%begin ('rank_info%unpack')
  n = n_io_rank_info
  write (io_unit%log,*) 'recv buffer =', buffer(1:5)
  call anonymous_copy (n, buffer, io_rank_info)
  if (io%verbose>1) then
    write (io_unit%log,*) 'load_balance%unpack: rank', io_rank_info%rank
    flush (io_unit%log)
  end if
  if (io_rank_info%rank==mpi%rank) return
  !-----------------------------------------------------------------------------
  ! Search for the relevant nbor_info
  !-----------------------------------------------------------------------------
  nbor_info => rank_info_list%head
  do while (associated(nbor_info))
    if (nbor_info%rank == io_rank_info%rank) exit
    nbor_info => nbor_info%next
  end do
  !-----------------------------------------------------------------------------
  ! If no nbor_info was found, allocate a new one and append
  !-----------------------------------------------------------------------------
  if (associated(nbor_info)) then
    write (io_unit%log,*) 'unpack: old', io_rank_info%rank
  else
    write (io_unit%log,*) 'unpack: new', io_rank_info%rank
    allocate (nbor_info)
    call rank_info_list%append (nbor_info)
  end if
  !-----------------------------------------------------------------------------
  ! Copy over info
  !-----------------------------------------------------------------------------
  nbor_info%ok    = io_rank_info%ok
  nbor_info%rank  = io_rank_info%rank
  nbor_info%cost  = io_rank_info%cost
  nbor_info%nq    = io_rank_info%nq
  nbor_info%n_swap= io_rank_info%n_swap
  nbor_info%time  = io_rank_info%time
  nbor_info%otime = io_rank_info%otime
  nbor_info%dtime = io_rank_info%dtime
  nbor_info%wall  = io_rank_info%wall
  nbor_info%owall = io_rank_info%owall
  wc = wallclock()-io_rank_info%wall
  if (io%verbose>1) then
    write (io_unit%log,'(a,i6,1p,g12.3,i6,2g16.6)') 'rank_info%unpack: rank,load,nq,time,latency =', &
      io_rank_info%rank, io_rank_info%cost, io_rank_info%nq, io_rank_info%time, wc
  end if
  call trace%end()
END SUBROUTINE unpack

!===============================================================================
!> Append to the rank_info_list -- called from init_nbors to initialize list
!===============================================================================
SUBROUTINE add (self, rank)
  class(load_balance_t):: self
  class(rank_info_t), pointer:: nbor_info
  type(mesg_t), pointer:: mesg
  integer:: rank
  logical:: found
  !.............................................................................
  if (rank==mpi%rank) then
    print *,mpi%rank,'WARNING: trying to add same rank to nbor_info'
    return
  end if
  found = .false.
  call nbor_info%lock%set
  nbor_info => rank_info_list%head
  do while (associated(nbor_info))
    if (nbor_info%rank == rank) then
      found = .true.
      exit
    end if
    nbor_info => nbor_info%next
  end do
  !-----------------------------------------------------------------------------
  ! For each new rank, allocate an nbor_info data type and the corresponding
  ! message and message buffer, and then issue the first recv request into that
  ! buffer.
  !-----------------------------------------------------------------------------
  if (found) then
    if (io%verbose>2) then
      write (io_unit%log,*) 'rank_info%add: already on list', rank
    end if
  else
    allocate (nbor_info)
    nbor_info%rank = rank
    allocate (mesg)
    nbor_info%mesg => mesg
    mesg%nbuf = n_io_rank_info
    allocate (mesg%buffer(mesg%nbuf))
    call mesg%recv (rank, mesg%tag)
    call rank_info_list%append (nbor_info)
    if (io%verbose>1) then
      write (io_unit%log,*) 'rank_info%add', rank, rank_info_list%n
    end if
  end if
  call nbor_info%lock%unset
END SUBROUTINE add

!===============================================================================
!> Append to the rank_info_list
!===============================================================================
SUBROUTINE append (self, rank_info)
  class(rank_info_list_t):: self
  class(rank_info_t), pointer:: rank_info
  !.............................................................................
  call trace%begin ('rank_info%append')
  if (associated(self%head)) then
    self%tail%next => rank_info
  else
    self%head => rank_info
  end if
  self%tail => rank_info
  self%n = self%n+1
  call trace%end()
END SUBROUTINE append

!===============================================================================
!> Remove an item from the rank_info_list.
!===============================================================================
SUBROUTINE remove (self, this)
  class(rank_info_list_t):: self
  class(rank_info_t), pointer:: this, rank_info, prev
  !.............................................................................
  call trace%begin ('rank_info%remove')
  call self%lock%set
  nullify (prev)
  rank_info => self%head
  do while (associated(rank_info))
    if (associated(rank_info,this)) then
      !-------------------------------------------------------------------------
      ! This item is not head, so jump over it from prev
      !-------------------------------------------------------------------------
      if (associated(prev)) then
        prev%next => this%next
      !-------------------------------------------------------------------------
      ! This item is head, and if this is the last item, head becomes null
      !-------------------------------------------------------------------------
      else
        self%head => this%next
      endif
      !-------------------------------------------------------------------------
      ! This item is tail, and if this is the last item, tail becomes null
      !-------------------------------------------------------------------------
      if (associated(this,self%tail)) then
        self%tail => prev
      end if
      self%n = self%n-1
      exit
    end if
    prev => rank_info
    rank_info => rank_info%next
  end do
  !-----------------------------------------------------------------------------
  ! If this item was not in the list, it is nevertheless quietly deallocated
  !-----------------------------------------------------------------------------
  deallocate (this)
  call self%lock%unset
  call trace%end()
END SUBROUTINE remove

!===============================================================================
!> Send a small package with load information to all nbor ranks, adding the
!> message to a list of sent messages, and checking the list for completed
!> messages
!===============================================================================
SUBROUTINE send (self)
  class(rank_info_list_t):: self
  class(rank_info_t), pointer:: nbor_info
  class(mesg_t), pointer:: mesg
  !.............................................................................
  if (.not. associated(self%head)) return
  call trace%begin('rank_info%send')
  !-----------------------------------------------------------------------------
  ! Send to all ranks in the rank_info list (which is sorted by rank)
  !-----------------------------------------------------------------------------
  allocate (mesg)
  mesg%nbuf = n_io_rank_info
  allocate (mesg%buffer(mesg%nbuf))
  write (io_unit%log,*) 'mk3',rank_info%rank
  call load_balance%pack (rank_info, mesg)                      ! pack into mesg
  write (io_unit%log,*) 'mk4',rank_info%rank
  write (io_unit%log,*) 'mesg%buffer =', mesg%buffer(1:5)
  call self%lock%set
  nbor_info => self%head                                        ! first rank_info
  do while (associated(nbor_info))                              ! until end
    if (io%verbose>1) then
      write (io_unit%log,'(f12.6,2x,a,2i5,1p,e12.3)') &
        wallclock(), 'rank_info%send', nbor_info%rank, &
        rank_info%rank, rank_info%cost
      flush (io_unit%log)
    end if
    call mesg%send (nbor_info%rank, mesg%tag)                   ! send it
    nbor_info => nbor_info%next                                 ! next rank_info
  end do
  call nbor_sent_list%add (mesg)                                ! add to list
  call nbor_sent_list%remove_completed                          ! remove completed
  call self%lock%unset
  call trace%end()
END SUBROUTINE send

!===============================================================================
!> Send a small package with load information to all nbor ranks
!===============================================================================
SUBROUTINE recv (self)
  class(rank_info_list_t):: self
  class(rank_info_t), pointer:: nbor_info
  class(mesg_t), pointer:: mesg
  !.............................................................................
  if (.not. associated(self%head)) return
  call trace%begin('rank_info%recv')
  !-----------------------------------------------------------------------------
  ! Send to all ranks in the rank_info list (which is sorted by rank)
  !-----------------------------------------------------------------------------
  call self%lock%set
  nbor_info => self%head                                        ! first rank_info
  do while (associated(nbor_info))                              ! until end
    mesg => nbor_info%mesg
    if (mesg%completed()) then                                  ! previous mesg?
      if (io%verbose>1) then
        write(io_unit%log,*) 'rank_info_list%recv: from', nbor_info%rank
        flush(io_unit%log)
      end if
      call load_balance%unpack (mesg%buffer)                    ! if recvd, unpack
      call mesg%recv (nbor_info%rank, tag=mesg%tag)             ! start a new receive
    end if
    nbor_info => nbor_info%next                                 ! next rank_info
  end do
  call self%lock%unset
  call trace%end()
END SUBROUTINE recv

!===============================================================================
!> Interpolate the local code time to the wall clock time nbor%wall (the latest
!> known for nbor), and return the difference between that and nbor%time. A
!> positive value means that nbor is ahead of the local rank.
!> Evaluating on queue size, we want a formula that only turns positive when
!> two conditions are fulfilled:  1) The nbor queue is getting short, AND 2)
!> local queue is long enough.  We want the formula to become agressive when
!> the load imbalance starts to get serious.
!===============================================================================
FUNCTION imbalance (self, nbor) RESULT (diff)
  class(rank_info_t):: self
  class(rank_info_t), pointer:: nbor
  real(8):: p, time, diff
  !.............................................................................
  !p = (nbor%wall-self%owall)/(self%wall-self%owall)
  !time = self%otime + p*(self%time-self%otime)
  !diff = (nbor%time-time)/self%dtime
  !-----------------------------------------------------------------------------
  ! This turns on (positive) when nbor%nq < self%nq*q_min/q_max, but we also
  ! do not want the formulate to become extremely sensisitve to values below
  ! q_min and q_max
  !-----------------------------------------------------------------------------
  diff = 2.0*(q_min/(q_min+nbor%nq)-q_max/(q_max+self%nq))
END FUNCTION imbalance

!===============================================================================
!> Compute a measure of the task load, which for patches is the number of cells
!> divided by the time step.
!===============================================================================
SUBROUTINE measure_load (self, head)
  class (rank_info_t):: self
  class (link_t), pointer:: head
  class (link_t), pointer:: link
  class (task_t), pointer:: task
  real:: load, sum, sum_cost, cells, sum_cells, ready
  real(8):: dt, sum_dt, wc
  integer, save:: itimer=0
  logical:: ok, active
  !-----------------------------------------------------------------------------
  call trace%begin ('rank_info%measure_load', itimer=itimer)
  !
  ok = .true.
  link => head
  do while (associated(link))
    ok = merge(.false., ok, link%task%rank==mpi%rank .and. link%task%dtime==0d0)
    link => link%next
  end do
  rank_info%ok = ok                             ! active patches have non-zero dtime
  if (.not. ok) then
    rank_info%dtime = 1.0
    call trace_end (itimer)
    return
  end if
  !
  sum_dt = 0.0
  sum_cost = 0.0
  sum_cells = 0.0
  link => head
  do while (associated(link))
    task => link%task
    select type (task)
    class is (patch_t)
      if (task%rank==mpi%rank) then
        cells = product(task%mesh%n)
        sum_cells = sum_cells + cells
        sum_cost = sum_cost + cells/task%dtime
      end if
    end select
    link => link%next
  end do
  !-----------------------------------------------------------------------------
  ! cost = number of cell updates per code time unit
  !-----------------------------------------------------------------------------
  rank_info%cost = sum_cost                     ! total rank update cost
  rank_info%rank = mpi%rank                     ! local rank
  write (io_unit%log,*) 'mk0', rank_info%rank, mpi%rank
  rank_info%dtime = sum_cells/sum_cost          ! cell-weighted dtime
  wc = wallclock()
  if (wc > rank_info%wall) then
    rank_info%owall = rank_info%wall            ! previous wall time
    rank_info%wall  = wc                        ! wall time
    rank_info%otime = rank_info%time            ! previsou queue time
    rank_info%time  = 0.9*rank_info%time  &     ! smoothed ..
                    + 0.1*head%task%time        ! .. queue time
  end if
  if (io%verbose > 1) &
    write (io_unit%log,'(a,i5,1p,3e12.3)') 'measure_load: nq,load,cost,dt =', &
      rank_info%nq, rank_info%cost, rank_info%dtime
  call trace%end (itimer)
END SUBROUTINE measure_load

!===============================================================================
!> Look up the load for a neighbor rank
!===============================================================================
FUNCTION find (self, rank, debug) RESULT (nbor_info)
  class(rank_info_list_t):: self
  integer:: rank
  logical, optional:: debug
  class(rank_info_t), pointer:: nbor_info
  !.............................................................................
  call trace%begin('rank_info_list%find')
  nbor_info => self%head
  if (present(debug)) then
    write (io_unit%log,*) 'debug: associated =', associated(nbor_info)
    do while (associated(nbor_info))
      write (io_unit%log,*) 'debug: rank =', nbor_info%rank
      if (nbor_info%rank == rank) then
        return
      end if
      nbor_info => nbor_info%next
    end do
    flush (io_unit%log)
  else
    do while (associated(nbor_info))
      if (nbor_info%rank == rank) then
        return
      end if
      nbor_info => nbor_info%next
    end do
  end if
  call trace%end()
END FUNCTION find

!===============================================================================
!> Print a rank_info list
!===============================================================================
SUBROUTINE print_lb (self, time)
  class(load_balance_t):: self
  real(8):: time
  class(rank_info_t), pointer:: nbor_info
  real:: load_diff, imbalance
  !.............................................................................
  if (.not.rank_info%ok) return
  call self%lock%set
  nbor_info => rank_info_list%head
  do while (associated(nbor_info))
    load_diff = (rank_info%cost-nbor_info%cost)/rank_info%patch_cost
   !imbalance = (nbor_info%time-rank_info%time)/rank_info%dtime
    imbalance = rank_info%imbalance (nbor_info)
    write (io_unit%log,'(2f12.6,2x,a,i6,1p,4g12.3,3i6)') &
      wallclock(), &
      time, &
      'rank_info_list: rnk,load,time,cost[12],wall,nq =', &
      nbor_info%rank,load_diff,imbalance, &
      nbor_info%cost, rank_info%cost, &
      nbor_info%nq, rank_info%nq, nbor_info%n_swap
    nbor_info => nbor_info%next
  end do
  call self%lock%unset
END SUBROUTINE print_lb

!===============================================================================
!> Decide whether to give up ownership of a patch, to increase the load of an
!> nbor task that needs more load. After a rank passes the critical threshold
!> below, there is a delay before it's boundary patches are sent to its nbor
!> ranks, are unpacked, and end up in a load_balance comparison.  This will
!> lead to a burst of patch transfers, and potentially oscillatory behavior.
!> It is better to transfer the LB info separately, in small packages that do
!> not take long to transfer; this is implemented.
!>
!> The measure of imbalance used below is defined in rank_info_mod::imbalance.
!> Ideally, it should contain both a measure of the actual load, the time skew,
!> and the size of the ready queue on the two ranks being compared.
!===============================================================================
FUNCTION check_load (self, head) RESULT (sell)
  class (load_balance_t):: self
  class (link_t), pointer:: head, nbor
  logical:: sell
  class (task_t), pointer:: task
  class (patch_t), pointer:: patch
  class(rank_info_t), pointer:: nbor_info
  integer,save:: delay=0
  logical:: load_condition, time_condition
  real(8):: wc
  real:: load_diff, cost, imbalance, randomu
  logical, save:: make_estimate=.true.
  integer, save:: itimer=0
  !-----------------------------------------------------------------------------
  ! Only one thread should do load balancing, and that thread should make sure
  ! to set the task list omp lock whenever it needs to access the task list.
  !-----------------------------------------------------------------------------
  sell = .false.
  if (.not.self%on) return
  call trace%begin ('load_balance%check_load', itimer=itimer)
  call self%lock%set
  wc = wallclock()
  patch => task2patch(head%task)
  rank_info%nq = head%task%nq
  !-----------------------------------------------------------------------------
  ! Update the load balance calculation for the local rank, and enter into the
  ! rank_info_list, which is also updated via MPI
  !-----------------------------------------------------------------------------
  if (wc > next_info) then
    next_info = next_info + cadence
    rank_info%cadence = cadence
    rank_info%rank = mpi%rank
    rank_info%patch_cost = product(patch%mesh%gn)/patch%dtime
    call rank_info%measure_load (head)
    call rank_info_list%send
    call rank_info_list%recv
    call load_balance%print (head%task%time)
  end if
  !-----------------------------------------------------------------------------
  ! If load balancing is on, and we have information, and it's time, or if an
  ! earlier case has left an excess, go ahead
  !-----------------------------------------------------------------------------
  if (rank_info%ok .and. wc<duration) then
    !---------------------------------------------------------------------------
    ! Among the virtual patches that surround the head boundary patch, find one
    ! that needs more load and give the head patch to it
    !---------------------------------------------------------------------------
    nbor => head%nbor
    do while (associated(nbor))
      if (io%verbose>1) &
        write (io_unit%log,'(a,2i9,3i6,2f12.6,l3)') 'LB: ids,nqs,rank,times', &
          head%task%id, nbor%task%id, rank_info%nq, nbor%task%nq, nbor%task%rank, &
          nbor%task%time, head%task%time, nbor%task%is_set(bits%virtual)
      if (nbor%task%is_set (bits%virtual)) then
        nbor_info => rank_info_list%find (nbor%task%rank)
        if (nbor%task%rank == mpi%rank) then
          write (io_unit%log,*) &
            'rank_info_mod::check_load virtual bit on my rank', nbor%task%id
          flush (io_unit%log)
        else if (associated(nbor_info)) then
          imbalance = rank_info%imbalance (nbor_info)/grace
          imbalance = max(imbalance, -1.)
          !---------------------------------------------------------------------
          ! If the imbalance measure is posive then give a patch to the remote
          ! rank, with a probability essentially proportional to the imbalance,
          ! but saturating at 5%, to limit the number of swaps per unit time.
          ! A swap can cause a fair number of patch transfers, since new virtual
          ! patches on the remote need at least two time slices.
          !---------------------------------------------------------------------
          randomu = self%random%ran1()
          if (io%verbose>0) &
            write (io_unit%log,'("LB:",2i4,2x,2l1,2f6.2,l4)') &
              mpi%rank,nbor%task%rank,rank_info%ok,nbor_info%ok,imbalance, &
              randomu,randomu < 0.05*(1.-exp(-imbalance))
          if (rank_info%ok.and.nbor_info%ok .and. &
              imbalance > 0.0 .and. &
              randomu < 0.05*(1.-exp(-imbalance))) then
            if (io%verbose>0) then
              print 1, &
                wc,'LB: rank',mpi%rank,' gives patch',head%task%id,' to',nbor%task%rank, &
                excess, nbor_info%n_swap, &
                nbor_info%cost, rank_info%cost
                1 format(f12.6,2x,a,i6,a,i9,a,i6,2i5,1p,2g12.3)
              write (io_unit%log,2) &
                wc,'load_balance: giving patch',head%task%id, ' to',nbor%task%rank, &
                excess, nbor_info%n_swap, &
                nbor_info%cost, rank_info%cost
                2 format(f12.6,2x,a,i9,a,i6,2i5,1p,2g12.3)
              flush (io_unit%log)
            end if
            call list%give_to (head, nbor%task%rank)
            sell = .true.
            if (io%verbose>0) &
              write (io_unit%log,*) 'swapped boundary to virtual:', head%task%id
            exit
          end if
        else
          write (io_unit%log,*) &
            'check_load  ERROR: nbor_info not associated, rank', nbor%task%rank
          nbor_info => rank_info_list%find (nbor%task%rank, debug=.true.)
          flush (io_unit%log)
        end if
      else if (nbor%task%is_set (bits%external)) then
        write (io_unit%log,*) nbor%task%id, 'LB: external status on nbor from rank', nbor%task%rank
      else if (nbor%task%rank /= mpi%rank) then
        write (io_unit%log,*) nbor%task%id, 'LB: inconsistent status on nbor from rank', nbor%task%rank
      end if
      nbor => nbor%next
    end do
  end if ! (rank_info%ok .and. wc < duration)
  call self%lock%unset
  call trace%end(itimer)
END FUNCTION check_load

END MODULE load_balance_mod
