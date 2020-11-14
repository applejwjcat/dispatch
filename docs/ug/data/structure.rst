Data Structure
----------------

Data from execution of experiments ends up under the subdirectory ``data/``.
It is often convenient to let ``data/`` be a softlink to a directory on a
dedicated disk system (e.g. a Luster file system on a cluster, or an external
disk drive on a workstation or laptop).
When using the default input file (``input.nml``) data is stored directly
in ``data/``, while if using e.g. ``run.nml``, the data is stored in
``data/run/``.

Metadata describing the snapshots is stored as namelists in files such as
::

   data/params.nml
   data/00000/snapshot.nml
   data/00000/rank_00000_patches.nml

The binary data may, depending on I/O method, reside in files such as::

   data/snapshots.dat
   data/00000/snapshot.dat
   data/00000/00000.dat

.. toctree::
   :maxdepth: 3

