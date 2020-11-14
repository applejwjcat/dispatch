Overriding Options
==================

If you prefer to compile with another set of options, do for example::

  make OPT="-O3 -xHost"

Any other of the macro names shown by ``make info`` can also be replaced::

  make PAR=
  make MPI=

would compile without OpenMP and without MPI, respectively.

.. toctree::
   :maxdepth: 3


