#!/bin/bash

# Aim: test that you can submit to each of the queues

s=$(basename -- "$0")
resultsfile="results."${s%.*}
temporaryfile=temp.err

queue_errors() {
   if grep error "$1" 
   then
      echo "FAILED " $2 | tee -a $resultsfile
   fi
}


date > $resultsfile

queues=("batch" "debug" "gpu" "smp" "skylake" "vnc")
#queues=("debug")
for i in "${queues[@]}"
do
   salloc -n 1 -p $i srun echo "hello" 2> $temporaryfile
   queue_errors $temporaryfile $i
done

# cleanup
rm $temporaryfile

