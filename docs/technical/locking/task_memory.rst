OpenMP locking time and contention
----------------------------------

A task typically has 26 nbors -- possibly more in AMR situations.  To get the
guard cell values takes of order 10-30% percent to the update time, so at most
of order 1% per source task.

To update the array memory takes a small fraction of the update time, so perhaps
again of order 1% of the update time.

The life cycle of task has an period when the task is not busy, which typically
is 50 times longer than the the task updat time.  Hence the locking periods of
time are extremely short in comparison to the task update cadence, and the 
chance the several target tasks are asking for the lock on a source while it
is holding the lock is extremely small.

Hence, to conservatively lock the tasks while changing the task memory should
give hardly any measurable impact on speed, while not doing it opens a small but
non-zero change of memory conflict.

NOTE 1: The task does not need to prevent external memory access while doing
things such as ``task%pack`` and ``task%courant_condition``, since these
procedures are performed by the thread that owns the task.

NOTE 2: On the other hand, while a virtual task is being unpacked, it should
lock the memory, to prevent collisions with target tasks using it as source in
guard cell loading.

.. toctree::
   :maxdepth: 3

   locking_measures
   locking_timings
