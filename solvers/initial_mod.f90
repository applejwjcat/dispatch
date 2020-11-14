!===============================================================================
!> Simple initical condition module for tests
!>
!> Note that the isothermal and gamma parameters are communicated from the solver
!> via the hydro_parameters module.
!===============================================================================
MODULE initial_mod
  USE io_mod
  USE trace_mod
  USE mesh_mod
  USE index_mod
  implicit none
  private
  type, public:: initial_t
  contains
    procedure:: init
    procedure:: condition => void
    procedure, nopass:: cleanup
  end type
CONTAINS

!===============================================================================
!> Setup a uniform initial state, with density=d0 and B=B0
!===============================================================================
SUBROUTINE init (self, solver, gamma1)
  class(initial_t):: self
  character(len=64):: solver
  real, optional:: gamma1
  !----------------------------------------------------------------------------
END SUBROUTINE init

!===============================================================================
SUBROUTINE cleanup
END SUBROUTINE cleanup

!===============================================================================
!> Void initializer
!===============================================================================
SUBROUTINE void (self, m, ff, idx)
  class(initial_t) :: self
  type(index_t):: idx
  class(mesh_t)    :: m(3)
  real, dimension(:,:,:,:) :: ff
END SUBROUTINE void

END MODULE
