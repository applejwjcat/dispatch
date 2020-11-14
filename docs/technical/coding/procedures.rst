Procedures
--------------

Procedures should follow this template, with a dotted line separating argument
declarations from local variable declarations, and with dashed lines separating code
and comment blocks:::

  !===============================================================================
  !> Procedure description (picked up by doxygen)
  !===============================================================================  
  SUBROUTINE updatet (self, aux)
    class(some_t):: self
    integer:: aux
    !..............................................................................
    integer:: local_variables, ...
    real(KindScalarVar), dimension(:,:,:), pointer:: d, ...
    real(KindScalarVar), dimension(:,:,:), allocatable:: w, ...
    !------------------------------------------------------------------------------
    call trace%begin('some_t%update)
    ...
    !------------------------------------------------------------------------------
    ! Comment block
    !------------------------------------------------------------------------------
    ...
    var = expression                                    ! in-line comment
    ...
    call trace%end ()
  END SUBROUTINE update

or, if the procedures should be timed:::

  !===============================================================================
  !> Procedure description ...
  !===============================================================================  
  SUBROUTINE updatet (self, aux)
    class(some_t):: self
    integer:: aux
    !..............................................................................
    integer:: local_variables, ...
    real(KindScalarVar), dimension(:,:,:):: d, ...
    integer, save:: itimer
    !------------------------------------------------------------------------------
    call trace%begin('some_t%update, itimer=itimer)
    ...
    call trace%end (itimer)
  END SUBROUTINE update


.. toctree::
   :maxdepth: 3
