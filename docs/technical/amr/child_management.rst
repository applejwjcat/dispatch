Child task management
----------------------

Steps when a new AMR task is created

1. The task is created, with no nbor list, and w/o being present in any nbor
   list, with only interior interpolated data from the parent

2. It is sent directly to the ready queue

3. The thread call check_current, notices a bits%init_nbor, and generates
   a new nbor list with ``tlist%init_nbor (link)``

4. That is enough to download guard cell data

   * Some cells may need to be interpolated from L-2 nbors, which must be there,
     since otherwise the parent patch would not have had support
   * This is quite OK, since the data are interpolated in any case

5. The procedure also sets bits%init_nbor in the nbor tasks, but does not itself
   generate new nbor lists for its nbors

6. When the nbor tasks come up for updating, they too will generate new nbor
   lists, because of the bits%nbor status bit

7. With the nbor lists initialized, everything has arrived at a new order,
   and the next ``check_nbors()`` call will include testing of the new child
   patch.

Using this strategy, we are able to avoid calling ``init_nbor_nbors()`` after
creating a new AMR task, and we are also able to avoid calling ``check_nbor_nbors()``,
since the nbors will take care of their own ``init_nbors()``.


.. toctree::
   :maxdepth: 4

