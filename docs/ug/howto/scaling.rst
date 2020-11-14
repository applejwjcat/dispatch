scaling_mod.f90
====================

The ``scaling_mod.f90`` specifies the relations between physical and code units.
To create it, copy the template file ``microphysics/scaling_mod.f90`` (or copy
an existing ``experiments/*/scaling_mod.f90`` file).

The contents should be essentially self-explanatory.  By choosing three scaling
units, for example *length*, *time*, and *mass*, all other units are defined.

The three basic units may be expressed in CGS or SI units; both units systems are
present in the template file.

.. toctree::
   :maxdepth: 4

