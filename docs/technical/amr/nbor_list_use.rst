Nbor list use
---------------------

Nbor lists are used for these purposes, in logical order

1) In ``list_t%check_ready()`` the nbor list is used to figure out if a task is
   ready to be updated, by comparing the states of tasks with the function
   ``task_t%is_ahead_of()``.

2) After the task gets picked from the ready queue, e.g. by 
   ``dispatcher0_t%update``, the nbor list is used by ``task_t%dnload`` to pick
   up the information from its nbors that it needs, in order to update.

3) After the task has updated, ``list_t%check_nbors()`` uses the nbor list to
   determine which nbor tasks to run ``list_t%check_ready()`` on.
   
   the nbor list of some task that depends on the
   active task is used to check if that task became ready to update after the
   current task updates.  Such tasks are on the nbor list of the active task,
   and has a flag ``needs_me`` set.

.. toctree::
   :maxdepth: 4
