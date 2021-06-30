#!/bin/bash
#SBATCH -J roc_code              # job name
#SBATCH -e roc_code.%j.err       # error file name
#SBATCH -o roc_code.%j.out       # output file name
#SBATCH -N 1                      # request 1 node
#SBATCH -n 16                     # request all 16 cores
#SBATCH -t 34:00:00               # designate max run time
#SBATCH -p skx-normal             # designate queue
#SBATCH --mail-user=nickriveira@utexas.edu
#SBATCH --mail-type=all
module load matlab
matlab -nodesktop -nodisplay -nosplash < CrossValidateSleepAwakeClassifier2.m
