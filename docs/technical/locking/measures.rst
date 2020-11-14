Lock timing
------------

TODO: One could generalize the current pair of calls:::

  call object%lock%set ('label')
  ...
  call object%lock%unset ('label')
  
to (with a meachnism very similar to ``trace%begin / trace%end``)::

  integer, save:: ilock=0
  ...
  call object%lock%set ('label', ilock=ilock)
  ...
  call object%lock%unset (ilock)

and then inside ``lock%set`` measure the time it took to get the lock, and
inside ``lock%unset`` measure the time the lock was held:

   SUBROUTINE set (self, label, ilock)
   ...
   lock%start(thread) = wallclock()
   ... set lock ..
   lock%acquire(thread,ilock) = &
   lock%acquire(thread,ilock) + (wallclock()-lock%start(thread))
   lock%start(thread) = wallclock()

   SUBROUTINE unset (self, label, ilock)
   ...
   ... unset lock ..
   lock%held(thread,ilock) = &
   lock%held(thread,ilock) + (wallclock()-lock%start(thread))


.. toctree::
   :maxdepth: 4

