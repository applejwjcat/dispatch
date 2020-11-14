Auxiliary data
---------------------------------

The auxiliary data resides either in **data/run/SSSSS/RRRRR_PPPPP.aux** files
(one file per patch).

To add data fields to it, register a link to 1-D, 2-D, 3-D, or 4-D
data arrays, with:::

   USE aux_mod
   ...
   type (aux_t):: aux
   ...
   call aux%register ('name', array)


.. toctree::
   :maxdepth: 4
   
