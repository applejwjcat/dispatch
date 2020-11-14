Expression handling
-------------------

Expression handling should take place on four levels, in the most general case:

1. An arbitrary Pyhton expression is broken down into words, which may consist of
   * The left hand side of other expressions
   * Variables names
   * Python words -- built-in or module objects
2. If evaluation of such words leads to no result the word is given to the var()
   function
3. The var function checks of the word belongs to known key-words, which respresent
   compound variables, such as 'T' for temperature, where each solver may require
   a different numerical expression, needing as much as 8 primitive variables (in
   the case of computing temperature when total energy is stored).
   * Expressions in the var function uses the mem() function to get actual values
   (which in fact or memory maps into disk files)
4. Inside the mem() function, alphabetic keys (such as 'px') are translated to
   integer indices, which in turn determine the offsets of the memory maps into
   the disk files

The first two steps take place in the expression_parser(), while the third step
takes place in the var() function (possibly calling itself recursively), and the
4th step takes place in the mem() function.

In either the var() or mem() function, two aspect where the actual disk data may
differ should be compensated for:

1. The different solvers use different centering of some of the variables
2. The io%format parameter determines, for example, if density is stored as log
   density, or as linear density.

.. toctree::
   :maxdepth: 4
   
