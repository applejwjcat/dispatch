Snapshot restore
-----------------

When reading in AMR tasks, one needs to know the task type to be
able to create the task, into which the data is to be read.  The sequence of steps
needs to be

1. read the meta-data of a task
2. create the task
3. load data into the task
    
Clearly, the meta-data needs to contain information both about the task type, and
about the location of the task data on disk.

It would be nice if this could be semi-automatic, so detection of task type was
done by a required data type method.

A part of this issue is also the arrangement of different task types.  We should
be able to allow different solvers to exist, without insisting that one must be
the extension of another.  They should all be extensions of task_t, and some should
all be extensions of patch_t:::


                 task_t
                 /  |  \
                /   |   \
         task1_t    |    task2_t
                    |
                 patch_t
                /   |   \
               /    |    \
       patch1_t     |     patch2_t


.. toctree::
   :maxdepth: 4

 
