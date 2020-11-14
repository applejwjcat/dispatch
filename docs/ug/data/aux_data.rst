Auxiliary data
---------------------------------

One can add auxiliary data, which will be automatically added to
the set of variables accessed via the ``dispatch`` Python module,
by adding these lines in the source code:::

   USE task_mod
   USE aux_mod
   ...
   ...
   call task%aux%register ('name', array)

``array`` should be a pointer to a 1-D, 2-D, 3-D, or 4-D
real array.  The ``aux`` data type may be added to any
other sub-class of the ``task_t`` data type (e.g. as a
``patch%aud`` or an ``extras%aux``.


.. toctree::
   :maxdepth: 4
   
