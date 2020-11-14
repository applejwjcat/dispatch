extras_mod.f90 options
------------------------

The ``extras/`` directory, and the related ``extras_mod.f90`` template
file provide optional extra features, which are only linked into the
executable if explicitly selected.

In practice, this is done by copying the ``extras/extras_mod.f90``
template file to the ``experiments/whatever/`` directory, uncommenting
lines related to the selected extra features, and adding a line listing
those features in ``experiments/whatever/Makefile``.

.. toctree::
   :maxdepth: 4

   rt
   selfgravity
   sinkp
   spitzer
   tracep
   h5

