Modules
--------------

Modules should start with a description, with comment lines ``!>`` being 
automatically interpreted by ``doxygen`` at ``readthedocs.org``::

  !===============================================================================
  !> Module description ...
  !===============================================================================
  MODULE some_mod
  
Then follows ``USE`` of the modules needed, and an ``implicit none`` (that applies
also to all proceduress in the module)::

    USE io_mod
    USE kinds_mod
    USE ...
    implicit none
    
All variables and procedures in the module should by default be private, with the
exception of the data type definition, and a static instance of the data type, the
purpose of which is to provide access to static parameters, set for example from a
namelist, and given as default values to instances of the data type:::

    private
    type, public:: some_t
      integer:: verbose=0
    contains
      procedure:: init
      procedure:: update
    end type
    type(some_t), public:: some
  CONTAINS
  
  !===============================================================================
  !> Initialization
  !===============================================================================  
  SUBROUTINE init (self)
    class(some_t):: self
    ...
  END SUBROUTINE init
   
  !===============================================================================
  !> Update
  !===============================================================================  
  SUBROUTINE update (self)
    class(some_t):: self
    ...
  END SUBROUTINE update
  ...
  END MODULE some_mod

.. toctree::
   :maxdepth: 4


