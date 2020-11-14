Overview
=========

In order not ot be limited to use the initially existing task numbers when
sending MPI messages, the most general recieving method uses ``MPI_IMPROBE``
to learn which task a message is aimed for, the size of the message, and
its sequence number.  After receiving a reply from ``MPI_IMPROBE``, a buffer
is allocated, a non-blocking ```MPI_IMRECV`` is issued, and the message is
added to a ``recv_list`` of outstanding receive messages.  The messages in
the list are checked regularly (once per task update), and when the message
is complete the message object is moved to an ``unpk_list`` for unpacking.

A more efficient method, which should scale to any number of OpenMP threads,
is to split communication between the threads, so each thread handles a
limited set of virtual tasks, issuing an ``MPI_IRECV`` to each initially,
and re-issuing an ``MPI_IRECV`` each time a package has been received.  In
most or all cases the packages then arrive in the order being sent, but if
they do not, it is simple to add an out-of-order package to an unpack list,
just as in the case above.

Similarily, send requests are started with ``MPI_ISEND()`` calls, and the
requests are held on lists until each set of sends (each task is in general
sent to multiple ranks) is completed (as tested via ``MPI_TEST_ALL()``), at
which time the send buffer is deallocated and the send request is removed
from the ``sent_list`` and deleted.

It is an advantage to arrange this so that each thread maintain a thread-
private ``sent_list`` -- this avoids the need for OMP critical regions or
locks.

.. toctree::
   :maxdepth: 4

