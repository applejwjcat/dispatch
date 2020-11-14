Collecting patch metadata
---------------------------------

The list of patches is collected from the ``run/data/SSSSS/rank_RRRRR_patches.nml``
files (here ``SSSSS`` is a 5-digit snapshot number and ``RRRRR`` is a
5-digit MPI rank).  These files contain the metadata for all patches.

The actual data resides either in ``data/run/snapshots.dat`` (one file
for all snapshots), or in ``data/run/SSSSS/snapshot.dat`` (one file per
snapshot), or in ``data/run/SSSSS/RRRRR_PPPPP.dat`` (one file per patch).

.. toctree::
   :maxdepth: 4
   
