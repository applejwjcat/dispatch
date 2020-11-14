.. _compiling:

Compiling
=========

Typically, you need to use a ``module`` command to get access to a compiler
and MPI library.  This could be, for example::

   module load intel openmpi/intel

To compile, go to one of the expriments/ directories, and use ``make info``
to see macro names and values that would be used in ``make``:::

   cd experiments/turbulence
   make info

If the automatically selected make options shown are OK, just do:::

   make -j

If MPI is not available, add ``MPI=`` to the make command, and if the
(gfortran) compiler chosen by default is not appropriate add for example
``COMPILER=ifort``).  The directory ``config/compiler/`` shows which
compiler configurations are avaialable.
See also the :ref:`environment` section.

.. toctree::
   :maxdepth: 3

   command
   cygwin
   gui
   option_groups
   options

