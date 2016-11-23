#!/bin/sh

if [ -r /etc/JARVICE/jobenv.sh ]; then
    . /etc/JARVICE/jobenv.sh
fi

if [ -r /etc/JARVICE/jobinfo.sh ]; then
    . /etc/JARVICE/jobinfo.sh
fi

source /opt/mvapich2-2.2/enable

CORES=`cat /etc/JARVICE/cores | wc -l`

`which mpirun` -np $CORES -hostfile /etc/JARVICE/nodes $@
