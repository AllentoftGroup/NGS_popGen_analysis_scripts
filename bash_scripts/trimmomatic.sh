#!/bin/bash

BASE=${1}

R1=${BASE}"_R1_001.fastq.gz"
R2=${BASE}"_R2_001.fastq.gz"

OUT_P_R1=trimmomatic/`basename $BASE`_R1_paired.fastq.gz
OUT_P_R2=trimmomatic/`basename $BASE`_R2_paired.fastq.gz
OUT_UP_R1=trimmomatic/`basename $BASE`_R1_unpaired.fastq.gz
OUT_UP_R2=trimmomatic/`basename $BASE`_R2_unpaired.fastq.gz

trimmomatic PE -threads 10 \
${R1} ${R2} \
${OUT_P_R1} \
${OUT_UP_R1} \
${OUT_P_R2} \
${OUT_UP_R2} \
ILLUMINACLIP:TruSeq3-PE.fa:2:30:10

##trimmomatic PE -threads 10 ${R1} ${R2} ${OUT_P_R1} ${OUT_UP_R1} ${OUT_P_R2} ${OUT_UP_R2} ILLUMINACLIP:TruSeq3-PE.fa:2:30:10