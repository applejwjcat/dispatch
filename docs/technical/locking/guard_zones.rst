Memory locking for guard zones
-----------------------------------

When ``omp_lock%tasks`` is set, external read access to task memory is locked
while the task%update is actively modifying the task memory (this occupies only
a small fraction of the time to do ``task%update``), so the procedure is fully
thread-safe.  One can optimize this, at the cost of an extremely small chance
to get relatively bad guard cell values on occasion:

When download_link wants to access a source task, it would do:::

  !-----------------------------------------------------------------------------
  ! Acquire the task in locked mode, so nothing can change while we decide
  ! whether to keep it.  While we have the lock, we get the slot indices ``jt``
  ! and weights ``pt`` -- these are not going to change if we release the lock,
  ! and the source task updates -- unless it updates several times and those 
  ! slots are overwritten with newer time values.
  !-----------------------------------------------------------------------------
  call source%lock%set ('guard cells')
  call source%time_slots (target%time, jt, pt)
  !-----------------------------------------------------------------------------
  ! If the target%time is in the first available time slot,
  ! which is source%t(source%iit(1:2)), that first slot could possibly be 
  ! overwritten, in some very unusual cases, when the source task is just about 
  ! to switch in that slot as "new", and if the current task by chance is delayed 
  ! enough.  In that case, keep the lock until after guard zones are loaded.
  !-----------------------------------------------------------------------------
  if (target%time < source%t(source%iit(2))) then
    call target%get_guard_zones_from (source, jt, pt)
    call source%lock%unset ('guard cells')
  else
    call source%lock%unset ('guard cells')
    call target%get_guard_zones_from (source, jt, pt)
  end if

Note that the ``get_guard_cells from (source)`` procedure must rely on only
the source%it information, and
  
.. toctree::
   :maxdepth: 3

