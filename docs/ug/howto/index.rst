Setting up experiments
======================

To construct a new experiment
(*experiment* is essentially synonymous to *simulation* or *project*)
in DISPATCH one can often start out
from an existing experiment, clone it into a new ``experiments/whatever/``
directory, and modify or replace the existing files.  In fact, an
experiment is *completely* defined by the (relatively few) files that
are present in the specific ``experiments/whatever/`` directory.

The main files present there, and their funcionalities, are:

1. ``Makefile``: select the main solver responsible for evolving the experiment
2. ``experiment_mod.f90``: specify initial conditions (ICs) and boundary conditions (BCs)
3. ``scaling_mod.f90``: specify scaling between physical and code units
4. ``extras_mod.f90``: select additional functionalities from the ``extras/`` directory,
   such as *selfgravity*, *radiative transfer*, *auxiliary HDF5 output*,
   etc.
5. ``run.nml``: specify, in Fortran namlist input files (``*.nml``) the parameters
   of specific *runs* of the experiment.
6. ``python/*.{py,ipynb}``: provide Python support; e.g. for preparation of input
   and/or analysis of output

.. toctree::
   :maxdepth: 4

   Makefile
   experiment
   scaling
   extras/index
   input
   python
