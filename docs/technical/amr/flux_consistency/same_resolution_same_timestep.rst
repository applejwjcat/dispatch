Same resolution and timestep
----------------------------

Assume two task with the same resolution and the same timestep size are being
updated by one thread:::

   0------------+-----------------+----------------+------------+--- task A
   |----fA1-----|------fB2--------|
   |----fA1-----|------fB2--------|
   0------------+-----------------+----------------+------------+--- task B

Assume the thread updates task A first, using an estimate of the flux through
the interface between them computed based on internal values from A and values
in the guard cells obtained from task B.  The flux is saved, and is made available
to task B.

Then the thread updates task B, and would in fact compute exactly the same flux
at the interface, since it would have the values from task A in its guard cells.
Hence it doesn't matter which of the fluxes it uses, and there is no need for
flux corrections.

The same holds true if the two tasks are updated simultaneously by two threads.

.. toctree::
   :maxdepth: 4
