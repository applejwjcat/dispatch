Simple examples
---------------

These example illustrates how to access and display data from
snapshot 2 of a run with ``input.nml`` as input file (see :ref:`environment`
for the assumed setup):
::

   # Open snapshot 2 metadata
   import dispatch
   sn=dispatch.snapshot(2)
   ...
   # Plot the horizontal average of density
   import dispatch.select as dse
   z,f=dse.haver(sn,iv='d',dir=2)
   import matplotlib.pyplot as plt
   plt.plot(z,f)
   ...
   # Display a horizontal plane using YT
   import dispatch.yt as dyt
   ds=dyt.snapshot(2)
   import yt
   slc=yt.SlicePlot(ds,fld='density',axis=2,center=[.5.,.5,.5])
   slc.show()
   ...
   # Display a horizontal plane using dispatch.graphics
   import dispatch.graphics as dgr
   dgr.amr_plane(sn,iv='d',z=0.5)

For more general cases, see the :ref:`python` documentation

.. toctree::
   :maxdepth: 3

