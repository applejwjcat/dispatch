Nbor list protocol
-------------------

The nbor list handling is based on these principles:

1) Threads need to lock their nbor lists while updating them.  This has the 
   extra benefit that the updating does not require copying the nbor list in
   the mean time, except for the benefit of making the lock time as short as
   possible.  However, considering how relatively seldom nbor lists need to
   be updated, locking during update is the simplest and safest.

2) While accessing the nbor lists of other tasks (e.g. during ``check_nbors()``),
   threads must acquire a lock on the nbor list while using it, to ensure it
   isn't being changed in the meantime.  However, it must not modify the nbor
   lists of other tasks

3) The nbor lists presented to other tasks need not be completely up-to-date,
   but they must be *valid*, in the sense that the nbors exist and have
   the expected time advance.

4) If at some point in (wall clock) time a task (A) has an nbor list that
   contains an nbor (B) that does *not* have task A in its nbor list, then to
   avoid deadlocks, a ``check_ready()`` on task A must happen as a consequence
   of it being added to the nbor list of task B.

The lines with task memory locking should be marked with "TASK LOCK", while the 
nbor list locking should be marked with "LINK LOCK":


.. toctree::
   :maxdepth: 4
