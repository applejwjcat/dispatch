
Representation
----------------

To update the dust dynamics particle-by-particle is most easily
done by keeping the particle information in a linked list (similar
to the representation in the particle-in-cell plasma simulation
setup.

We can use the same basic data type, extending it with the attributes
that are particular to the dust-gas interaction.

Part of the representation is that the integer cell address is always
known.  The cost of computing the number density of each species is
thus linear in the number of particles; as one moves the particles,
their weights are summed up in each cell, and one thus arrives at their
respective number density in each cell.

Given the number density of each species, one computes the rates of
transformation from one species to the other using a kernel, and the
resulting rates are summed up in each cell.

The next time the particles are moved over a certain time interval, 
their respective weights are changed according to the rates for that
species.


.. toctree::
   :maxdepth: 4

