#!/bin/bash

# the path to the reference genome
#REF=/willerslev/datasets/reference_genomes/hs37d5/hs37d5.fa
REF=/science/willerslev/users-shared/science-snm-willerslev-rlw363/GCA_000001405.28_GRCh38.p13_genomic.fna
#number of threads to be used
THD=20

# the path to the read files all the way to where the names start changing
PRE=${1}
#the ID of the run
#ID=${2}
ID=`basename $PRE|cut -c1-15`
# the path to the folder that would store the output
TMP=${2}

#make the directory that will store the data (does this mean I don't need to create it before?)
#mkdir -p ${TMP}

# create the real path from the given path for the read folder
PRE=`realpath ${PRE}`
#create the real path from the given path to the folder everything will be stored in
TMP=`realpath ${TMP}`

### Why is there TMP instead of PRE?
# the full path to the collapsed reads
#R0=${TMP}/`basename ${PRE}`".collapsed.gz"
R0=${PRE}".collapsed.gz"
#echo "This is the R0 variable" ${R0}
# the full path to the R1 reads 
#R1=${TMP}/`basename ${PRE}`".pair1.truncated.gz"
R1=${PRE}".pair1.truncated.gz"
#echo "This is the R1 variable" ${R1}
# the full path to the R2 reads
#R2=${TMP}/`basename ${PRE}`".pair2.truncated.gz"
R2=${PRE}".pair2.truncated.gz"
#echo "This is the R2 variable" ${R2}

# sample name that will be the first 15 letters (it was originally six but this doesn't give a unique name to samples)
SM=`basename $PRE|cut -c1-15`
# library name, in my case it is irrelevant as I only did one extraction so I make it the sample name
#LB=`basename $PRE|cut -f1-2 -d-`
LB=SM
#identity of the sample (will be similar to the sample name)
ID2=${ID}_`basename ${R1}`
#Identity of the collapsed reads (will be the same as the collapsed reads
ID0=${ID}_`basename ${R0}`
#name of the regular reads bam file
ONAM=${TMP}/`basename $R2`.bam
#name of the collapsed read bam file
ONAM0=${TMP}/`basename $R0`.bam
FNAME=${TMP}/`basename $R2`_clean.fastq.gz
FNAME0=${TMP}/`basename $R0`_clean.fastq.gz
#echo $SM ${LB} ${ID} ${F}

# run the bwa mem program with the following parameters: -t is the number of threads; -r should be the number of seeds but here it is the parameters for the name; the reference and the reads. Then we pipe the samtools to sort the bam file and output it
bwa mem -M -t ${THD} -r "@RG\tID:${ID0}\tSM:${SM}\tCN:CGG\tPL:ILLUMINA\tLB:${LB}\tDS:maria.novosolov@sund.ku.dk" ${REF} ${R0}|samtools sort -m4G -@2 -o ${ONAM0}|samtools fastq -n -f 4 ${ONAM0}| gzip>${FNAME}
#same as above but with the the real reads
bwa mem -M -t ${THD} -r "@RG\tID:${ID2}\tSM:${SM}\tCN:CGG\tPL:ILLUMINA\tLB:${LB}\tDS:maria.novosolov@sund.ku.dk" ${REF} ${R1} ${R2} |samtools sort -m4G -@2 -o ${ONAM}|sametools fastq -n -f 4 ${ONAM0}| gzip>${FNAME0}

