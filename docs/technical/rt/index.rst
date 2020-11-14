Radiative Transfer
==================

Several radiative transfer solvers are implemented in the development
version of DISPATCH, and based on that experience we are recommending the
*short characteristics* method for general use, and including it in the public
version.

The ``experiments/stellar_atmosphere/`` directory demonstrates the use of
this solver in the context of stellar atmospheres.  The method is general,
however, with the choice of angles, opacity data, and boundary conditions
defining the specific case.

.. toctree::
   :maxdepth: 4

   nbors
   task_list
   hybrid/index
   sc/index
   pt/index
