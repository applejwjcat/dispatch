!===============================================================================
!> The solver_t data type extends the patch_t with a generic guard zone dnload
!> procedure, which covers the need for all simple, Cartesian mesh based 
!> solvers, and eliminates the need for a dnload procedure in each one of them.
!> It also adds restart functionality when initializing patches.
!===============================================================================
MODULE solver_mod
  USE io_mod
  USE trace_mod
  USE extras_mod
  USE patch_mod
  USE task_mod
  implicit none
  private
  type, public, extends(extras_t):: solver_t
  contains
    procedure:: init
    procedure, nopass:: cast2solver
    procedure:: update
    procedure:: void_fun
    procedure:: void_fun1
    procedure:: void_fun3
    procedure:: gas_pressure => void_fun
    procedure:: compression_magnitude => void_sub
    procedure:: vorticity_magnitude => void_sub
    procedure:: gas_velocity_vector => void_fun3
    generic:: gas_velocity => void_fun1, void_fun3
  end type
  type(solver_t), public:: solver
CONTAINS

!===============================================================================
!> Organize calls to the extras and the hydro solver
!===============================================================================
SUBROUTINE init (self)
  class(solver_t) :: self
  !.............................................................................
  call trace%begin ('solver_t%init')
  self%nw = 1
  call self%patch_t%init
  call self%extras_t%init
  self%idx%d = 1
  self%iit = 1
  call trace%end
END SUBROUTINE init

!===============================================================================
!> Cast a generic task_t to patch_t
!===============================================================================
FUNCTION cast2solver (task) RESULT(solver)
  class(task_t), pointer:: task
  class(solver_t), pointer:: solver
  !.............................................................................
  select type (task)
  class is (solver_t)
  solver => task
  class default
  nullify(solver)
  call io%abort ('patch_t%cast: failed to cast a task to patch_t')
  end select
END FUNCTION cast2solver

!===============================================================================
!> Organize calls to the extras and the hydro solver
!===============================================================================
SUBROUTINE update (self)
  class(solver_t) :: self
  !.............................................................................
END SUBROUTINE update

!===============================================================================
SUBROUTINE void_sub (self, pg)
  class(solver_t):: self
  real, dimension(:,:,:):: pg
  !-----------------------------------------------------------------------------
  pg = self%mem(:,:,:,1,1,1)
END SUBROUTINE void_sub

!===============================================================================
FUNCTION void_fun (self) RESULT (pg)
  class(solver_t):: self
  real, dimension(self%gn(1),self%gn(2),self%gn(3)):: pg
  !-----------------------------------------------------------------------------
  pg = self%mem(:,:,:,1,1,1)
END FUNCTION void_fun

!===============================================================================
FUNCTION void_fun1 (self, i) RESULT (v)
  class(solver_t):: self
  integer:: i
  real(4), dimension(self%gn(1),self%gn(2),self%gn(3)):: v
  !-----------------------------------------------------------------------------
  v = self%mem(:,:,:,1,1,1)
END FUNCTION void_fun1

!===============================================================================
FUNCTION void_fun3 (self) RESULT (v)
  class(solver_t):: self
  real(4), dimension(self%gn(1),self%gn(2),self%gn(3),3):: v
  !-----------------------------------------------------------------------------
  v = self%mem(:,:,:,1,1:3,1)
END FUNCTION void_fun3

END MODULE solver_mod
