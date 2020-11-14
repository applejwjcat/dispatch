Adding a new task
---------------------

When a thread adds a new task, either as a consequence of AMR on the same rank,
or because of AMR on another rank, or because of load balancing, it must always
take these actions:

* Make sure that ``class(patch_t)`` tasks have a link back to the task link

* Add an nbor list to the task link

* Cause the new task to be added to the nbor lists of the nbors, by calling
  ``list_t%set_init_nbors()``, which sets ``bits%init_nbors`` in all nbor tasks.

* Increment the task total and task level counts on the rank

* Call ``check_nbors()`` on the new task link, which then (as always) runs 
  ``check_ready()`` on all the nbors first, and then runs check_ready() on the 
  task link itself (unless it is a virtual task).

These actions are taken in a procedure ``list_t%add_new_task()`` that is called
from both the AMR procedure that created new tasks, and from the 
``task_mesg_t%unpack()`` procedure that creates virtual copies of new tasks, 
or that creates a new virtual task because that task became a boundary task
on the rank that owns it.


.. toctree::
   :maxdepth: 4
