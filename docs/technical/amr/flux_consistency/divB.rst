Conserving diV(B)
----------------------------

The divergence of the magnetic field should remain equal to zero at all
times and at all locations.  This condition is a *constraint* on the
magnetic field components passing through a cell, from which one can
determine the flux through one face from the fluxes through the other
five faces.  This may be used to enforce div(B)=0 at the interface
between two DISPATCH patches, with components centered like so:
::

        |        ||        |
        Bx  Bz   Bx   Bz   Bx  
        |        ||        |
   =====+===By===++===By===+=======
        |        ||        |
        Bx  Bz   Bx   Bz   Bx  
        |        ||        |
   -----+---By---++---By---+-----
        |        ||        |
        Bx  Bz   Bx   Bz   Bx  
        |        ||        |
   -----+---By---++---By---+-----
        |        ||        |
        Bx  Bz   Bx   Bz   Bx  
        |        ||        |
   =====+===By===++===By===+=======
        |        ||        |
        Bx  Bz   Bx   Bz   Bx  
        |        ||        |

The double line symbolizes the patch boundary, with the Bx magnetic
field component defined at the same location by two different tasks,
generally at a sequence of different times

The continuity of By(x) and Bz(x) through the face is guaranteed,
since any glitch would correspond to an electric current, which
would generate a counter-acting force.

The continuity of Bx(x) may then be enforced by simply computing
the Bx component at the interface from the other 5 known face flux
values: Bx(face) = Bx(internal) - delta(By) - delta(Bz) (where the
delta() has to be taken in the appropriate sense).

Initially, the values of By(z) at the upper y-edge, and the Bz(y)
values at the upper z-edge are not known, but they are subsequently
constructed, so after a few iterations also the edge and corner values
are consistent with div(B)=0, and the whole cube, including the ghost 
zones around it, is divergence free (if it was to begin with).

.. toctree::
   :maxdepth: 4
