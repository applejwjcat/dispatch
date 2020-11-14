Hyper-threading
---------------

If the system supports hyper-threading; e.g., 2 threads per core, with
10 cores per process:::

  #!/bin/bash
  #SBATCH --ntasks=64 --ntasks-per-node=2 --cpus-per-task=10 --ntasks_per_core=2
  #SBATCH --mem-per-cpu=3g --exclusive
  
  export OMP_NUM_THREADS=20
  ./dispatch.x

.. toctree::
   :maxdepth: 3

