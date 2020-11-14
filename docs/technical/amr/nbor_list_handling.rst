Nbor list handling
-------------------

If threads were to be allowed to update the nbor lists of tasks that another
thread might be working on, the situation would become complicated. The thread
would need to lock the nbor list of the other task while updating it, but
it cannot be allowed to lock it's own nbor list during that time, since the 
thread working on that task might happen to be running the same procedure at
the same time, and a deadlock could then occur.

If threads only ever change the nbor list of their active task, and leave changing
the nbor lists of other tasks to the threads updating those tasks, then much of 
the nbor list locking and copying can be avoided.  

When the active task accesses the nbor list of another task -- this happens 
primarily in ``check_nbors()``, it needs to be sure that the another thread
doesn't change the nbor list in the mean time, so it needs to lock it.  That
locking is only effective if a thread that updates its own nbor list actually
locks it when it does so.  Hence even with read-only access, the task owning
thread must lock the nbor list link while changing the nbor list.

Currently the generation of new nbor lists is primarily done by
``list_t%init_nbors()``.  If/when other procedures are used to modify nbor lists
they must lock the task link while doing so.


.. toctree::
   :maxdepth: 4
