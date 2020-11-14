Code
--------------

For consistency, and to maintain good readability even with many levels of indentation,
code should be indented with (only) two characters per level, as in this template:::

   SUBROUTINE proc (self, arg1, arg2, ...)
     class(type_t):: self
     ...
     select type (arg1)
     class is (solver_t)
       n = ...
     class is (extras_t)
       n = ...
     class default
       n = ...
     end select
     do i=1,n
       a(i) = ...
       if (a(i) > 0.) then
         b(i) = ...
       else
         b(i) = ...
       end if
     end do

.. toctree::
   :maxdepth: 4

