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

# create the output name based on the R1 name. In this case the cut values might need to be changed based on your file names 
SMPL=`basename $R1|cut -f1-3 -d_`

#Run AdapterRemoval. The adaptors should also be changed based on the adaptors used in your case
AdapterRemoval --file1 ${R1} --file2 ${R2} --minlength 30 --basename ${TMP}/${SMPL} --collapse  --gzip --adapter1 AGATCGGAAGAGCACACGTCTGAACTCCAGTCACNNNNNNNNATCTCGTATGCCGTCTTCTGCTTG --adapter2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTNNNNNNNNGTGTAGATCTCGGTGGTCGCCGTATCATT

