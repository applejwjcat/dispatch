Neighbor relations
--------------------

The ``nbors_t%init`` procedure in the ``solver/rt/$(RT_SOLVER)/nbors_mod.f90``
file establishes the necessary nbor (dependency) lists and flags.  It is called
in this context:::

   !dispatcher_t%execute
   !  rt_t%init_task_list (task_list)
   !    rt_t%nbors%init
   !      init_nbor_pair (task1, needs, task2, needs_me, download)
   !    rt_t%prepend_tasks_to (task_list)
   !      rt_t%init
   !      task_list%prepend_link (rt%link)
   !        task_list%prepend_link (rt%omega%link)
   !      

.. toctree::
   :maxdepth: 4
