Refine event sequence
--------------------

* In ``refine_t%make_child_patch()``

  * create the new patch
  * add its parent patch as the only nbor, and prolong
  * set ``bits%init_nbors``
  * add it to the task list
  * add it to the ready queue
  * switch perspective to the first time it enters 
    ``refine_t%check_current()``

* In ``refine_t%check_current()``

  * detect ``bits%init_nbors``
  * generate a new nbor list
  * possibly set ``bits%init_nbors`` on the nbors
  * clear ``bits%init_nbors``
  * continue the usual business

* In ``task_mesg_t%unpack()`` for virtual tasks

  * must do whatever an active task does; using ``list_t%add_new_link`` for that
  * must also detect ``bits%init_nbors``, and act accordingly


.. toctree::
   :maxdepth: 4


