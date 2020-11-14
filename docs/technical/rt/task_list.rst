Task list manipulation
-----------------------

The task list is first constructed by the ``component/`` procedure setting up
the arrangements of MHD tasks.  In the common case with a Cartesian arrangements
of ``patch_t`` tasks, the relevant file is ``components/cartesisan_mod.f90``.
The sequence of calls that happen are:::

   !cartesian%init
   !  task_list%init
   !    experiment_t%init
   !    task_list%append (experiment)

which results in a global ``task_list`` containing only the exeperiment tasks,
which in this case are ``solver_t`` tasks, where the task structure has been
extended in ``extras_t%init`` with a ``solver_t%rt`` RT task, which in turn
has extended itself with a set of `´solver_t%rt%omega(:)`` tasks, one for each
ray direction.
These extra tasks are referred to as "RT sub-tasks", and have not yet been
added to the task list, since ``cartesian_t%init()`` only adds the
``experiment_t`` tasks (cf. above).

To give all tasks access to the task list, before calling the specific 
``dispatcher_t%method()`` the  ``dispatcher_t%excute`` procedures calls each 
task with::

   !call task%init_task_list (task_list)

This provides the opportunity to add additional tasks to the tasks list (to
avoid a potential recursive disaster the new tasks are prepended rather than
appended). 
In the RT case, the ``rt_t%init_task_list(self,task_list)`` is first adds
the RT sub-tasks to the task list and then sets up the proper nbor relations 
between the new tasks and the already existing MHD tasks.

.. toctree::
   :maxdepth: 4
