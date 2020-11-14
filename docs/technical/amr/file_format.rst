MPI I/O for AMR
----------------

Currently, only the ``method='legacy'`` file format works with AMR, and then only
for writing -- restarts have not been implemented yet.
A new ``method='snapshot'`` will be implemented for efficient saving of AMR
data in a single ``data/run/NNNNN/snapshot.dat`` file per snapshot.

The structure of data on disk should be optimized for fast reading, and should
have a format that is independent of the MPI geometry.  This is achieved by
(temporarily) numbering all patches in a rank ``1...np``, where ``np`` is the 
number of patches at the time of writing. Then such blocks from all ranks are
arranged with each variable filling a contiguous piece in the snapshot.dat file;
viz::

  r1p1...r1pN, r2P1...r2pN, . . .,rMp1...rMpN
  
where ``M`` is the number of ranks and ``N`` is the number of patches per ranks
(which in general is allowed to differ from patch to patch).  A metadata file
gives, for each sequence number, the offset into the file, and the previous 
task number:::

  seq  rank var task offset
   1    0    0   1    xx
   .      
   N    0    0 
   .    .
   N    M    0
   .    .    .
   N    M    V

A restart does not need to result in the same tasks residing on the same rank as
before, but should achieve that whenever possible.  After or while reading in the 
metadata, each rank reads in as many as its share of the load

.. toctree::
   :maxdepth: 4

