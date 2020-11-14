Tasks
------

This is what the class hierarchy looks like when radiative transfer (RT)
is included:::

   !experiment_t -> solver_t -> mhd_t -> extras_t  -> gpatch_t -> patch_t -> task_t
   !                                      |---rt_t -> gpatch_t -> patch_t -> task_t
   !                                      |-grav_t -> gpatch_t -> patch_t -> task_t

The task list consist of 1) a number of "MHD tasks" (``experiment_t`` tasks),
and 2) A number of ``rt_t`` tasks, which subdivide into 2a)
one "main RT task" (an ``rt_t`` task) for each MHD task, and 2b)
``n_omega`` "RT sub-tasks" (also ``rt_t`` tasks)

Each MHD task has connections to the ``rt_t`` tasks via the ``extras_t`` class, and each
main RT task has connections to the RT sub-task, which are allocated as an array
of ``rt_t`` tasks inside the main ``rt_t`` task.
Each ``rt_t`` task also has a connection to the patch_t part of the MHD task, and can
thus access the MHD time and other attributes

The MHD task update procedure is called directly from task_list_t%update(), and
calls extras_t%pre_update before the MHD update, and extras_t%post_update after it.
Through that call path, ``rt_t%post_update`` is (only) called when the MHD task has
updated.   It is not called as part of the normal ``rt_t%update``.  This is the correct
point to detect that a new EOS calculation is needed.

The RT tasks are also called directly from the ``task_list_t%update()``, and as
illustrated above, they do not go through the ``extras_t`` layer.  Those calls go
only to ``rt_t%update()``.


.. toctree::
   :maxdepth: 4

