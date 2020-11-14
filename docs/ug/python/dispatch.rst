``dispatch`` module
-----------------------

Try for example::

  import dispatch
  help(dispatch)
  help(dispatch.snapshot)
  sn=dispatch.snapshot(<TAB>

To read the 1st snapshot from ``data/``, ``data/run``, and ``../data/run``, do::

  sn=dispatch.snapshot(1)
  sn=dispatch.snapshot(1,run='run')
  sn=dispatch.snapshot(1,'run',data='../data')

The resulting ``sn`` is an instance of the snapshot class, where many
of the Fortan data type attributes from the source code are available as
Python object attributes.  To see what is offered, do::

  dir(sn)

.. toctree::
   :maxdepth: 3

