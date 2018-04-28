#!/bin/bash

# Pause PBS, ssh to the nodes and test scripts.
#echo $PBS_NODEFILE
#cp $PBS_NODEFILE /home/zhuu/PBS_NODEFILE.txt
#sleep 3600

python=/data/data323/devl/zhuu/bin/python
mpiexec=/data/data323/devl/zhuu/bin/mpiexec
codedir=/home/zhuu/code/Distributed-TensorFlow-Using-MPI

export PS_HOSTS=$($python $codedir/cluster_specs.py --hosts_file=$PBS_NODEFILE --num_ps_hosts=1 | cut -f1 -d ' ')
export WORKER_HOSTS=$($python $codedir/cluster_specs.py --hosts_file=$PBS_NODEFILE --num_ps_hosts=1 | cut -f2 -d ' ')

echo "PBS_NODEFILE is" $PBS_NODEFILE
echo "PS_HOSTS is" $PS_HOSTS
echo "WORKER_HOSTS is" $WORKER_HOSTS
cp $PBS_NODEFILE /home/zhuu/PBS_NODEFILE.txt

# Below will run on every host in the PBS_NODEFILE.
$mpiexec -ppn 1 \
    $python -u $codedir/cluster_dispatch.py \
    --ps_hosts=$PS_HOSTS --worker_hosts=$WORKER_HOSTS \
    --script=$codedir/example.py
