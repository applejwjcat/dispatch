
Object hierarchy
====================

Main object hierarchy:::

   task_t               ! Basic task attributes; time, position, ...
   patch_t              ! Mesh based task attributes; mesh, dimensions, ...
   gpatch_t             ! A place to stick in IC value calls
   extras_t             ! Layer with selectable, extra features
   mhd_t                ! MHD layer
   solver_t             ! Generic layer, to present to experiments
   experiment_t         ! Experiment layer, BCs, ICs, forces, ...

.. toctree::
   :maxdepth: 3

   calls
   init_calls

 
