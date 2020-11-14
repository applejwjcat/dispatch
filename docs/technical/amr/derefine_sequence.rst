Derefine event sequence
------------------------

* Call ``list_t%remove_remove_and_reset()`` to

  * set bits%remove, which hides the task in check_ready() (task and nbor)
  * remove the task from the task list (it will remain in garbage bin while
    needed)
  * use the existing nbor list to set ``bits%init_nbors`` on nbors
  * now that the task is removed, call ``check_nbors()`` to see if nbors have
    become ready
  * move the task to the garbage bin
  * when the task is no longer needed (no longer is a member of an nbor list)
    the task is deallocated and deleted by ``list_t%garbage_remove()``

* In ``task_mesg_t%unpack()``

  * detect ``bits%remove`` and call ``list_t%remove_remove_and_reset()``

This is identical to what is done on the owner rank, and is taken care of by 
the ``list_t%remove_and_reset()`` procedure.

.. toctree::
   :maxdepth: 4


