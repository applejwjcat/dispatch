Data type hierarchy
-------------------

The ``sink_patch_t`` data type is an extenstion of the standard ``gpatch_t`` data
type, with access to the task list. 

The ``particle_solver_t`` is an extension of the ``particle_list_t`` data type, which
is a `` task_t``  extension that holds particle positions at several times.
The ``particle_solver_t`` is kept as an attribute of `` sink_patch_t`` data type,
so the data type hierarchy looks like this:
::

                                 task_list_t
                                  / |  |
                      experiment_t  |  |
                       solver_t     |  |
                         mhd_t      |  |
                           | refine_t  |
                           |  /        |
                        extras_t       |
                           |           |
                     sink_patch_t      |
                    /      |           |
          paricle_solver_t |           |
                   |       |           |
                   |     gpatch_t      |
                   |    /  |     \     |
                   |   /   |      list_t
           particle_list_t |     /  |
            /      |      patch_t   |
      particle_t dll_t    /   \     |
                         /     link_t
                        /       |
                  connect_t   task_t
 

.. toctree::
   :maxdepth: 4

