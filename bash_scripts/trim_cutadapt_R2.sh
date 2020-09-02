#!/bin/bash

# This script uses the program AdaptRemoval to remove all the adaptors from the reads to make them ready for downstream analysis
#the prefix of the name for all the files. Has to include the path all the way until the end of the common denominator of the read name 
PRE=${1}

#the output folder where to put all the reads without adaptors
TMP=${2}

#clean the names that are given by the user
PRE=`echo $PRE|sed -E 's#/+#/#g'`
TMP=`echo $TMP|sed -E 's#/+#/#g'`

#get the real path for the output directory
TMP=`realpath $TMP`

# Register the read file name for each of the pairs
R1=${PRE}_R1_001.fastq.gz
R2=${PRE}_R2_001.fastq.gz

TMP_R1=`echo ${PRE}|cut -f9 -d/`
TMP_R2=`echo ${PRE}|cut -f9 -d/`

R1R=${TMP}/${TMP_R1}_R1_cutadapt.fastq.gz
R2R=${TMP}/${TMP_R2}_R2_cutadapt.fastq.gz

cutadapt -u 15 -j 10 -o ${R2R} ${R2}
