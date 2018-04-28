#!/bin/bash

#PBS -q parallel@sasl0002
#PBS -l select=5:mpiprocs=1:ncpus=16:node_class=n16.128:accel=none:network=FEX
#PBS -l jg_n16_128_none_FEX_gsu_a=80
#PBS -N zhuu_test
#PBS -j oe -o "/home/zhuu/job.output.zhuu_test"
#PBS -W umask=002

# Pause PBS, ssh to the nodes and test scripts
#echo $PBS_NODEFILE
#cp $PBS_NODEFILE > /home/zhuu/PBS_NODEFILE.txt
#sleep 3600

python=/data/data323/devl/zhuu/bin/python
mpiexec=/data/data323/devl/zhuu/bin/mpiexec
codedir=/home/zhuu/code/Distributed-TensorFlow-Using-MPI

cp $PBS_NODEFILE /home/zhuu/PBS_NODEFILE.txt

export PS_HOSTS=$($python $codedir/cluster_specs.py --hosts_file=$PBS_NODEFILE --num_ps_hosts=1 | cut -f1 -d ' ')
export WORKER_HOSTS=$($python $codedir/cluster_specs.py --hosts_file=$PBS_NODEFILE --num_ps_hosts=1 | cut -f2 -d ' ')

echo "PBS_NODEFILE is" $PBS_NODEFILE
echo "PS_HOSTS is" $PS_HOSTS
echo "WORKER_HOSTS is" $WORKER_HOSTS

# PBS and MPI
# PBS only schedule and assign nodes.
# It runs once on one node (the PBS server?)
# It is up to you to manage what each node does (use mpiexec).

# ppn is processes per node

# NPROCS=wc -l < $PBS_NODEFILE
# mpiexec -n $NPROCS \

# Learn difference between mpiexec and mpirun
#mpiexec --hostfile $PBS_NODEFILE \
#mpiexec --hosts $WORKER_HOSTS \
#mpirun --hostfile $PBS_NODEFILE \

# The path of mpiexec must be the same as the Python mpi4py.get_config(),
# which module is used in the cluster_dispatch to get correct ranks.

$mpiexec -ppn 1 \
    $python -u $codedir/cluster_dispatch.py \
    --ps_hosts=$PS_HOSTS --worker_hosts=$WORKER_HOSTS \
    --script=$codedir/example.py

# save to file bash stdout
#    --script=$codedir/example.py | tee /home/zhuu/pbs.log
