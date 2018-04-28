#!/bin/bash

testdir=`pwd`
job="$testdir/distributed_tensorflow.sh"
outdir="$testdir"
#qsub=/usr/local/pbs/bin/qsub
#qsub=/usr/pbs/bin/qsub
qsub=/usr/bin/qsub

# -q name@host  queue name and pbs server to use
# -j oe         redirects stderr to stdout
# -o            directs stdout
# -l nodes=???  specifies the compute node to use

#$qsub -q parallel@hal-gate102 \
#      -l select=1:host=hal4680:mpiprocs=1:ncpus=16+1:host=hal4681:mpiprocs=1:ncpus=16  \
#      -M pdww@mailhost.xhl.chevrontexaco.net -m n \
#      -A SeisSupp:qtest102:r \
#      $job 

# Request 10 nodes, each node 16 CPUs, so in total 160 CPUs.
# so is the jg_n16_128_none_FEX_gsu_a=160, equals select * ncpus.
# Run 2 MPI processes per node, mpiprocs=2, so you have 20 joblets.
# It does not mean you have 14 idle CPUs in each node.
# Each joblet may use several CPUs, depending on your script/code.
#$qsub -q parallel@sasl0002 \
#      -l select=10:mpiprocs=2:ncpus=16:node_class=n16.128:accel=none:network=FEX \
#      -l jg_n16_128_none_FEX_gsu_a=160 \
#      -N zhuu_test -r n \
#      -j oe -o "$outdir/job.output.zhuu_test" \
#      -W umask=002 \
#      $job

$qsub -q parallel@sasl0002 \
      -l select=5:mpiprocs=1:ncpus=16:node_class=n16.128:accel=none:network=FEX \
      -l jg_n16_128_none_FEX_gsu_a=80 \
      -N zhuu_test -r n \
      -j oe -o "$outdir/job.output.zhuu_test" \
      -W umask=002 \
      $job
