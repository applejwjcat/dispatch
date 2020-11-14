Experiments
===========

A few of the (many more) experiments from the development
repository are made available in the public version, mainly
to serve as examples of how to construct experiments, and how
to implement solvers.
Assuming you have the gfortran compiler and MPI (if not --
see :ref:`compiling`), downloading, compiling, and running for
example the ``heat_diffusion`` demo requires only these commands:
::

   git clone https://bitbucket.org/aanordlund/dispatch
   cd dispatch/experiments/heat_diffusion
   make -j
   ./dispatch.x


.. toctree::
   :maxdepth: 3

   heat_diffusion
   mhd_shock
   pan
   stellar_atmospheres
   truelove
   turbulence
