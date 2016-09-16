This is an mvapich2 base image for MPI applications. It also has a SLURM-compatible mvapich2 build.

To activate mvapich2:

```bash

source /opt/mvapich2-2.2/enable
```

or with SLURM

```bash

source /opt/mvapich2-2.2-slurm-16.05.4/enable
```
The toolchain is built with gcc-4.9 using devtoolset-3.

Example usage:

```bash

mpirun -np 32 -hostfile /etc/JARVICE/nodes echo hello
```



