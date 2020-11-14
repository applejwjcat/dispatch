Turbulence
------------

The ``turbulence/`` experiment demonstrates how to set up the driving in
forced turbulence experiments, where the details of the driving
may need to depend on the value of the SOLVER makefile macro.

The hierachical makefile setup (which may be followed by inspecting
the ``config/Makefile`` and its ``sinclude`` statements allows one
to override the default choice of the ``force_mod.f90`` or
``forces_mod.f90`` by placing corresponding files in subdirectories
under the ``experiments/turbulence/`` directory.

The specific driver in the case where ``SOLVER=ramses/hydro``, for
example, resides in ``experiments/turbulence/ramses/hydro/``.

Alternative, as illustrated by the directory ``experiments/turbulence/stagger2e/``,
one may place a specialized experiment in a subdirectory, where the
``TOP`` makefile macro is correspondingly defined as ``TOP=../../..``.


.. toctree::
   :maxdepth: 4

