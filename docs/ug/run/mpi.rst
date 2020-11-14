Running under MPI
-----------------

Use the relevant cluster documentation to find out how to run
under MPI.  To use SLURM to run a job with 64 MPI processes,
with two processes per node and 10 cores per process, you
may need something similar to this (which would work on HPC.KU.DK)::

  #!/bin/bash
  #SBATCH --ntasks=64 --ntasks-per-node=2 --cpus-per-task=10
  #SBATCH --mem-per-cpu=3g --exclusive

  export OMP_NUM_THREADS=10
  ./dispatch.x

.. toctree::
   :maxdepth: 3

