Receive procedures
-------------------

In order not to be limited to use the initially existing task numbers when
sending MPI messages, the most general recieving method uses ``MPI_IMPROBE``
to learn which task a message is aimed for, the size of the message, and
its sequence number.  After receiving a reply from ``MPI_IMPROBE``, a buffer
is allocated, a non-blocking ```MPI_IMRECV`` is issued, and the message is
added to a ``recv_list`` of outstanding receive messages.  The messages in
the list are checked regularly (once per task update), and when the message
is complete the message object is moved to an ``unpk_list`` for unpacking.

A more efficient method, implemented in ``check_active()`` and
``check_virtual()``, which should scale to any number of OpenMP threads,
is to split communication between the threads, so each thread handles a
limited set of virtual tasks, issuing an ``MPI_IRECV`` to each initially,
and re-issuing an ``MPI_IRECV`` each time a package has been received.  In
most or all cases the packages then arrive in the order being sent, but if
they do not, it is simple to add an out-of-order package to an unpack list,
just as in the case above.

Data type and procedures:::

   task_mesg_t%check_mpi
     task_mesg_t%check_priv
       task_mesg_t%unpack
       mpi_mesg_t%get
       mpi_mesg_t%add
       mpi_mesg_t%remove
       mpi_mesg_t%delete
       mesg_t%is_in_order
     task_mesg_t%check_virtual
       mesg_t%irecv
       mesg_t%is_complete
       mesg_t%is_in_order


.. toctree::
   :maxdepth: 4

