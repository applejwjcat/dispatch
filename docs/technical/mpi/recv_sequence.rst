Receiving order
---------------

A rank sends packages to several nbor ranks, so each rank also receives packages
from several nbor ranks.  It is important that these packages are received in
the same order as they were sent from the sender rank, so the MPI protocol
ensures that.

Each package sent from a rank to another rank contains a ``tag``, which encodes
the task ID and the sequence number.   Each rank keeps track of the sequence
number from other ranks in an atomic fashion.
This is is handled by ``task_mesg_t%check_priv()`` and is detected when looping
over the list of messages ready for unpacking.  The procedure makes sure to call
``task_mesg_t%unpack()`` in sequential order.  This is totally transparent to
the underlying procedures (e.g. ``patch_t%unpack()``, and detection of
out-of-order messages is thus not  needed there.

.. toctree::
   :maxdepth: 4

