#!/bin/bash

#the folder of where the .bam files are
IN=mapping_temp
#The folder that will be used for saving all the output files to
OUT=picard_temp
#garbage directory for all the tempfiles of MarkDuplicates
JUNK=picard_MD_junk
#the optical distance used for reads to be considered optical duplicates. Optical duplicates are reads that fell on the same tile during the sequencing process?
OPT_DIST=12000

#make a directory with the OUT argument
mkdir -p ${OUT}
mkdir -p ${JUNK}
#run a loop that will take each bam file and run the markDuplicates function from picard
# start the picard program and run the Mark Duplicates; indicate on the size of the optical duplicates; the input folder;
#the output folder; the name for the metric file

#for f in ${IN}/*.bam 
for f in `ls mapping_temp/*.bam|grep pair2`
do
    echo "java -Djava.io.tmpdir=${JUNK} -jar /willerslev/software/picard.jar MarkDuplicates OPTICAL_DUPLICATE_PIXEL_DISTANCE=${OPT_DIST} I=${f} o=${OUT}/`basename ${f} .bam`.md.bam REMOVE_DUPLICATES=false METRICS_FILE=${OUT}/`basename ${f} .bam`.md.bam.metrics TAGGING_POLICY=All VALIDATION_STRINGENCY=LENIENT MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=4000"
done
