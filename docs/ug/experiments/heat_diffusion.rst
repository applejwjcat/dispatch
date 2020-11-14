Heat diffusion
---------------

The ``heat_diffusion/`` experiment demonstrates how to setup an experiment that refers
to the very simple solver ``solvers/heat_diffusion/solver_mod.f90``,
and by extension demonstrates how to add a solver (any solver) to the
DISPATCH code framework.

The entire solver and experiment setup is defined by the files::

   solvers/heat_diffusion/Makefile
   solvers/heat_diffusion/solver_mod.f90
   experiments/heat_diffusion/Makefile
   experiments/heat_diffusion/experiment_mod.f90
   experiments/heat_diffusion/input.nml


.. toctree::
   :maxdepth: 4

