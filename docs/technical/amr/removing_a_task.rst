Removing a task
---------------------

When a thread removes a task, either as a consequence of AMR on the same rank,
or because of AMR on another rank, or because of load balancing, it must always
take these actions:

* Immediately set ``bits%move`` bit in the task status (under a brief lock).
  That bit should make the task effectively removed, immediately.   Hence, even
  if it still exists, and is in the nbor lists of some tasks, it is ignored in
  ``check_ready()`` calls.

* While the task is being processed for removal, it is placed on a garbage list,
  as it may still be needed in task updates.   While that is going on, the task
  may still be used in ``dnload()`` procedures.

* When the access count (n_needed) reaches zero, because the task has been removed
  from all nbor lists where it was present, the garbage collection routine is free
  to actually deallocate everything, and remove the last traces of the task.

To be precise on a particular aspect here:  As long as a task that used to have
it in its nbor list has it there, it needs to be able to provide guard cell data.
But when the nbor list has been update and the task in question is not there 
anymore, then the task list presumably contains other tasks that provide the same
guard cell coverage, and hence the task may be actually removed.   Hence; the use
in ``dnload()`` is tied one-to-one on the presence in the nbor list, so 
``download_link()`` should not take the remove bit into account.

The functionaly described above is taken care of by ``list_t%remove_and_reset()``


.. toctree::
   :maxdepth: 4
