!===============================================================================
!> This module contains all experiment specific setup necessary to solve the
!> heat diffusion problem in DISPATCH
!===============================================================================
MODULE experiment_mod
  USE io_mod
  USE trace_mod
  USE solver_mod
  implicit none
  private
  !-----------------------------------------------------------------------------
  ! The experiment relies on the solver selected by SOLVER=heat_diffusion in
  ! the experiment Makefile.  It extends it, and overloads the init and update
  ! procedures, to be able to set parameters and do I/O.
  !-----------------------------------------------------------------------------
  type, public, extends(solver_t):: experiment_t
  contains
    procedure:: init
    procedure:: update
  end type
CONTAINS

!===============================================================================
!> Read experiment parameters and use them to set solver parameters
!===============================================================================
SUBROUTINE init (self)
  class(experiment_t):: self
  !.............................................................................
  integer:: iostat
  real, save:: initial_temperature=1, outside_temperature=2., courant=0.1
  logical, save:: first_time=.true.
  namelist /experiment_params/ courant, initial_temperature, outside_temperature
  !-----------------------------------------------------------------------------
  call trace%begin('experiment_t%init')
  !-----------------------------------------------------------------------------
  ! The OpenMP critical region (input_cr) ensures that only the first thread
  ! that arrives here reads from the namelist file.
  !-----------------------------------------------------------------------------
  !$omp critical (input_cr)
  if (first_time) then
    rewind (io%input)
    read (io%input, experiment_params, iostat=iostat)
    if (iostat/=0) call io%namelist_warning ('experiment_params', iostat < 0)
    write (io%output, experiment_params)
    first_time = .false.
  end if
  !$omp end critical (input_cr)
  !-----------------------------------------------------------------------------
  ! Other threads inherit the saved parameters and set them in all tasks
  !-----------------------------------------------------------------------------
  ! the same parameters when they setup subsequent tasks.
  self%initial_temperature = initial_temperature
  self%outside_temperature = outside_temperature
  !-----------------------------------------------------------------------------
  ! Initialize the solver, setting up memory arrays, coordinates, etc
  !-----------------------------------------------------------------------------
  call self%solver_t%init
  self%courant = courant
  self%time = 0d0
  call trace%end
END SUBROUTINE init

!===============================================================================
!> Update the solution, after first possibly saving snapshot data
!===============================================================================
SUBROUTINE update (self)
  class(experiment_t):: self
  !----------------------------------------------------------------------------
  call trace%begin('experiment_t%update')
  call self%output
  call self%solver_t%update
  call trace%end
END SUBROUTINE update

END MODULE experiment_mod
