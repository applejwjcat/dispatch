Searching
---------

Show the commit messages of files (in any branch) that contain "string":::

   git log -G'\<string\>' --all

Show the commit messages of files (in any branch) that added or removed "string":::

   git log -S'\<string\>' --pickaxe-regex --all


.. toctree::
   :maxdepth: 4
