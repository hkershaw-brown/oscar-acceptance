#!/bin/bash -x

#AIM: compile and run npb mpi benchmarks and record the time

TESTDIR=$PWD
NPBDIR=/users/hkershaw/scratch/centos7/acceptance_tests/npb/centos_NPB3.3.1/NPB3.3-MPI
MPIMOD=mvapich2/2.0rc1-intel

cd $NPBDIR
module load $MPIMOD

make clean
make bt NPROCS=64 CLASS=D

cd $TESTDIR 

cat <<EOF > npb_centos.sh
#!/bin/bash

#SBATCH -N 4-4 
#SBATCH --ntasks-per-node=16
#SBATCH -o $TESTDIR/npb-test-D-centos.%j.out
#SBATCH -e $TESTDIR/npb-test-D-centos.%j.out
#SBATCH -D $NPBDIR
#SBATCH -t 1:00:00

module load $MPIMOD

time srun -n 64 bin/bt.D.64

EOF

sbatch npb_centos.sh
myq

