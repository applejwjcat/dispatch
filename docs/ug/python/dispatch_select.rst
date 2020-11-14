``dispatch.select`` module
-----------------------------------

``dispatch.select`` contains support functions for choosing
selections of snapshot data.

Try for example::

  s,f=dispatch.select.haver(sn,dir=2)
  plot(s,f)

which returns in ``f`` the "horizontal" averages of the density
when "up" is axis 2 (the z-axis).  ``s`` contains the coordinate
values (z in this case).  Or try plotting horizontal min- and
max-values, using::

  s,f0,f1=dispatch.select.hminmax(sn,dir=2)
  plot(s,f0); plot(s,f1)

.. toctree::
   :maxdepth: 4
   
