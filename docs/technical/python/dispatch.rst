Python ``dispatch`` module
==========================

The ```dispatch.snapshot()``` procedure returns an object where the most
important attribute is ```snapshot.patches```, which is a list of patch
objects (```p```), carrying attributes (e.g. ```p.size```) that generally
have the same name as the corresponding variables in the code.

.. toctree::
   :maxdepth: 4
   
   collecting_patches
   mapping_data
   aux_data
