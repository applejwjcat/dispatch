!===============================================================================
!> This module contains all experiment specific information necessary to solve
!> the heat diffusion problem in DISPATCH
!===============================================================================
MODULE solver_mod
  USE io_mod
  USE trace_mod
  USE extras_mod
  implicit none
  private
  type, public, extends(extras_t):: solver_t
    real, pointer:: radii(:,:,:)
    real, pointer:: temperature(:,:,:)
    real:: initial_temperature=1.0
    real:: outside_temperature=2.0
    real:: radius=0.45
  contains
    procedure:: init
    procedure:: update
    procedure:: boundary_condition
  end type
CONTAINS

!===============================================================================
!> Setup an initial state.  The box size is 1, with the origin at 0,0,0, so
!> the max radius is 0.5
!===============================================================================
SUBROUTINE init (self)
  class(solver_t):: self
  integer:: m(6), i1, i2, i3, it
  !-----------------------------------------------------------------------------
  call trace%begin('solver_t%init')
  !-----------------------------------------------------------------------------
  ! This initializers a default do-nothing solver, and allocates the
  ! self%mem() 6-dimenstional array (nx,ny,nz,nv,nt,nw), in which the 4th
  ! index (= 1) here is the variable index, and the 5th index is the time slot.
  !-----------------------------------------------------------------------------
  self%nv = 1
  self%nt = 5
  call self%patch_t%init
  self%temperature => self%mem(:,:,:,1,1,1)
  self%temperature = self%initial_temperature
  !-----------------------------------------------------------------------------
  ! For convenience, we also allocate the radius (distance from origin) for
  ! each cell.  The array should have the same size as the temperature:
  !-----------------------------------------------------------------------------
  m = shape(self%mem)
  allocate (self%radii(m(1),m(2),m(3)))
  do i3=1,m(3)
  do i2=1,m(2)
  do i1=1,m(1)
    !---------------------------------------------------------------------------
    ! Each mesh (x,y,z) has properties stored in a data type (object), where
    ! %p is the position (of the center), and %r are the relative cell positions
    !---------------------------------------------------------------------------
    self%radii(i1,i2,i3) = sqrt((self%mesh(1)%p + self%mesh(1)%r(i1))**2 + &
                                (self%mesh(2)%p + self%mesh(2)%r(i2))**2 + &
                                (self%mesh(3)%p + self%mesh(3)%r(i3))**2)
  end do
  end do
  end do
  !-----------------------------------------------------------------------------
  ! Set temperature inside and then apply boundary condition
  !-----------------------------------------------------------------------------
  call self%boundary_condition (1)
  call trace%end
END SUBROUTINE init

!===============================================================================
!> Apply the boundary condition T=temperature(1) outside the given radius
!===============================================================================
SUBROUTINE boundary_condition (self, it)
  class(solver_t):: self
  integer:: it
  real, pointer, contiguous:: f(:,:,:)
  !-----------------------------------------------------------------------------
  call trace%begin('solver_t%boundary_condition')
  !-----------------------------------------------------------------------------
  f => self%mem(:,:,:,1,it,1)
  where (self%radii > self%radius)
    f = self%outside_temperature
  end where
  call trace%end
END SUBROUTINE boundary_condition

!===============================================================================
!> Update the solution, by adding a fraction times the diffusion operator
!===============================================================================
SUBROUTINE update (self)
  class(solver_t):: self
  real, pointer, contiguous:: v(:,:,:)
  real, allocatable:: d2f(:,:,:)
  integer:: m(3), i1, i2, i3
  integer, save:: itimer=0
  !----------------------------------------------------------------------------
  call trace%begin('solver_t%update', itimer=itimer)
  call self%output
  !----------------------------------------------------------------------------
  ! Copy the variable (temperature) from the current slot (%it) to the %new slot
  !----------------------------------------------------------------------------
  v => self%mem(:,:,:,1,self%new,1)
  v =  self%mem(:,:,:,1,self%it ,1)
  call self%boundary_condition (self%new)
  !----------------------------------------------------------------------------
  ! Allocate a scratch variable for the diffusion (Laplace) operator
  !----------------------------------------------------------------------------
  m = shape(v)
  allocate (d2f(m(1),m(2),m(3)))
  !----------------------------------------------------------------------------
  ! Evaluate a 6-point diffusion operator over the internal patch region
  ! (no need to do it in the guard zones)
  !----------------------------------------------------------------------------
  do i3=self%mesh(3)%li,self%mesh(3)%ui
  do i2=self%mesh(2)%li,self%mesh(2)%ui
  do i1=self%mesh(1)%li,self%mesh(1)%ui
    d2f(i1,i2,i3) = v(i1+1,i2  ,i3  ) &
                  + v(i1-1,i2  ,i3  ) &
                  + v(i1  ,i2+1,i3  ) &
                  + v(i1  ,i2-1,i3  ) &
                  + v(i1  ,i2  ,i3+1) &
                  + v(i1  ,i2  ,i3-1) &
                  - v(i1  ,i3  ,i3  )*6.0
  end do
  end do
  end do
  !----------------------------------------------------------------------------
  ! Set the time step, update the temperature, and apply boundary condition
  !----------------------------------------------------------------------------
  self%dtime = self%courant
  v = v + self%dtime*d2f
  call self%boundary_condition (self%new)
  !----------------------------------------------------------------------------
  ! Clean up and count operations
  !----------------------------------------------------------------------------
  deallocate (d2f)
  call self%counter_update
  call trace%end (itimer)
END SUBROUTINE update

END MODULE solver_mod
