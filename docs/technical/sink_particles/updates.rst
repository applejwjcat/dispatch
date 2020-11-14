Task update sequence
---------------------

When a sink particle task (data type ``sink_patch_t``) reaches the head of
the ready queue and is taken by one of the threads, its call to the normal
``task_list_t%update()`` procedure results in calls to these procedures
(indentation indicates call level, and the name of the file containing
the procedure is obtained with the substituttion ``_t`` -> ``_mod.f90``):
::

   experiment_t%dnload                                          ! generic download call
     sink_task_t%dnload                                         ! sink patch download
       download_t%download_link (..., all_cells=.true., ...)    ! values for accretion
   task%update                                                  ! generic update call
     sink_task%update                                           ! sink patch update
       particle_solver_t%force_field                            ! fall through
         particle_list_t%force_field                            ! compute forces
           hash_table%get                                       ! get patch_forces
       sink_task_t%accrete                                      ! accrete mass
         sink_task_t%courant_condition                          ! set timestep
       sink_task_t%move                                         ! organize particle move
         particle_solver_t%update                               ! particle solver update
           particle_solver_t%courant_time                       ! particle courant time
   patch_t%rotate                                               ! patch periodicty etc
     task_t%rotate                                              ! rotate time slots
   list_t%send_to_vnbors [ if the task is a boundary task ]     ! send boundary tasks

.. toctree::
   :maxdepth: 4

