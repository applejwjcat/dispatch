Short characteristics
=====================

Short characteristics radiative transfer solvers typically solve the radiative
transfer equations across only a single cell (or in some cases even a fraction
of a cell) at a time.  In three dimensions one can nevertheless achieve excellent
performance, by parallelizing over perpendicular directions -- effectively solving
for the radiation over parallel planes, progressing from one plane to the next,
starting from a boundary where values are known, either from physical boundary
conditions, or from boundary values taken from an adjacent ("up-stream") domain.

Because one is looping over two redundant directions, it is possible to significantly
reduce the cost, since it allows the compiler to use loop vectorization.

The ``solvers/rt/short_characteristics/`` directory contains the following
modules, used to perform various parts of such solutions:::

  radau_mod.f90                 ! Radau integration -- a modified Gauss integration
  rt_integral_mod.f90           ! integral method solver
  rt_mod.f90                    ! RT data type definitions
  rt_nbors.f90                  ! RT neighbor setup
  rt_solver_mod.f90             ! RT solver data type


.. toctree::
   :maxdepth: 4

   radau
   sched
   tasks
