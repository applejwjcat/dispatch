Handling ``bits%init_nbors``
----------------------------

When a thread updating a boundary task discovers a ``bits%init_nbors``,
it should not clear that bit until *after* the ``send_to_vnbors()`` call,
since the bit needs to be propagated to virtual copies of the task.

The nbor list should not be updated too early, since the thread is updating the
task because it was deemed ready to update based on the existing nbor list,
which has then been used (before the call to ``task%update()``) to load data
into the guard zones. The existing nbor list might also be used for some
unspecified reason as part of the update, so it should not be touched until
after the task has updated.

Hence the ``init_nbors()`` call should be done by ``task_list_t%update()``,
*after* its call to ``task%update()``, and before the call to 
``send_to_vnbors()``.

The call to ``send_to_vnbors()`` is immediately preceeded by a
call to ``load_balance()``, which means the boundary task that will have 
a new nbor list generated could possibly be reassigned to another rank.
It will, in any case, since it arrives with ``bits%init_nbors`` set, have
a new nbor list generated also on the other rank, so the result will in
any case be that both the first rank and the other rank will have consistent
nbor lists for the task.

The state of that task after the ``task%update()`` and ``init_nbors()`` is that
of a "dormant" task, ready to be checked as a candidate for the ready queue by 
any thread updating one of its (possibly new) nbors.  That is at it should be.


.. toctree::
   :maxdepth: 4
