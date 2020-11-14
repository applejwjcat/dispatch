python/*.{py,ipynb} files
--------------------------

Use a ``python/`` sub-directory to store ``*.py`` and ``*.ipynb``
(Jupyter Notebooks).  This is where to put the *experiment specific*
Python files.

Functionalities that may be used in any context should instead
be added to ``utilities/python/``, or should be amended to for
example ``utilities/python/dispatch/_dispatch.py`` or other
files there.

For details about data access via Python, see the :ref:`data_access` section.


.. toctree::
   :maxdepth: 4

