Scheduling
----------

Radiative transfer tasks need not be updated with the same cadence as their
MHD "host" tasks.  The scheduling relations are illustrated below.

Phase 1: MHD updates are done, until ``mhd%time >= mhd%rt_next``
(``=omega%time`` for all omega):::

   ------------- BC --------------------------------------
   ------------- MHD1 ------------+  |
   --------------RT1  ---------------+
                                     |
   ------------- MHD2 -------------+ |
   --------------RT2  ---------------+

Phase 2: EOS2 calculations, at ``time = mhd%rt_next``, setting ``eos_time`` to this
time.  Here, EOS2 has advanced, and with MHD2 time ahead, only lack of upstream
RT prevents RT2 update::

   ------------- BC --------------------------------------
   ------------- MHD1 -------------+ |
   --------------RT1  ---------------+
                                     |
   ------------- MHD2 ---------------|-+
   --------------EOS2 ---------------+
   --------------RT2  ---------------+

Phase 3: EOS1 calculations, at ``time = mhd%rt_next``, setting ``eos_time`` to this
time.  Here, EOS2 has advanced, and with MHD2 time ahead, only lack of upstream
RT prevents RT2 update::

   ------------- BC --------------------------------------
   ------------- MHD1 ---------------|+
   --------------RT1  ---------------+
                                     |
   ------------- MHD2 ---------------|-+
   --------------EOS2 ---------------+
   --------------RT2  ---------------+

Phase 4: RT1 is now detected as "ready", while RT2 is waiting::

   ------------- BC --------------------------------------
   ------------- MHD1 ---------------|+
   --------------RT1  ---------------|--------+
                                     |
   ------------- MHD2 ---------------|-+
   --------------EOS2 ---------------+
   --------------RT2  ---------------|--------+

If the RT update time ``rt_time`` is *smaller* than ``mhd%dtime``, it could happen that
the next time the MHD task is updated, it finds itself still ahead of the RT
time, and hence that MHD task (but not all of them, advances it's RT time again).

A simple solution would be to limit the MHD update time interval to ``rt_time``, for
all patches that do RT.  This could impact the cost a bit, but only when the 
choice of RT time is made very conservative

.. toctree::
   :maxdepth: 4

