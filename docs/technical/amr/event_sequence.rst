Event sequences
-------------------

If threads only ever change the nbor list of their active task, and leave changing
the nbor lists of other tasks to the threads updating those tasks, then much of 
the nbor list locking and copying can be avoided.  The choice is made by not 
setting ``omp_lock%links`` in task%refine

When the active task accessed the nbor list of another task -- this happens 
primarily in ``check_nbors()``, it needs to be sure that the another thread
doesn't change the nbor list in the mean time, so it needs to lock it.  However,
it does not need to lock it's own nbor list during that time.

Each thread needs to lock its own active tasks nbor list in ``init_nbors()``, while
it is being changed, and then needs to lock the nbor's nbor lists when they are
being used (``in check_nbors()``).

Each thread needs to lock it's own task memory while it is being changed (inside
the hd_t%update or in timestep_t%update), and then needs to lock the memory of
nbors as it accesses it (in ``download_t%download_link()``).  
