#!/bin/bash

#the folder of where the .bam files are
IN=bam_cutadapt
#The folder that will be used for saving all the output files to
OUT=bam_cutadapt/picard_cutadapt
#garbage directory for all the tempfiles of MarkDuplicates
JUNK=picard_MD_junk
#the optical distance used for reads to be considered optical duplicates. Optical duplicates are reads that fell on the same tile during the sequencing process?
OPT_DIST=12000

#make a directory with the OUT argument
#mkdir -p ${OUT}
#mkdir -p ${JUNK}
#run a loop that will take each bam file and run the markDuplicates function from picard
# start the picard program and run the Mark Duplicates; indicate on the size of the optical duplicates; the input folder;
#the output folder; the name for the metric file

#for f in ${IN}/*.bam 
for f in `ls ${IN}/*.bam`
do
    java -XX:ParallelGCThreads=15 -Djava.io.tmpdir=picard_MD_junk -jar ~/miniconda3/envs/PS_proj/share/picard-2.23.3-0/picard.jar  MarkDuplicates OPTICAL_DUPLICATE_PIXEL_DISTANCE=${OPT_DIST} I=${f} o=${OUT}/`basename ${f} .bam`.md.bam REMOVE_DUPLICATES=false METRICS_FILE=${OUT}/`basename ${f} .bam`.md.bam.metrics TAGGING_POLICY=All VALIDATION_STRINGENCY=LENIENT MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=4000
done

#java -Djava.io.tmpdir=${JUNK} -jar /willerslev/software/picard.jar MarkDuplicates -OPTICAL_DUPLICATE_PIXEL_DISTANCE 12000 -I bam_cutadapt/P13204_157_S172_L001paired.bam -o bam_cutadapt/picard_cutadapt/P13204_157_S172_L001paired.md.bam -REMOVE_DUPLICATES false -METRICS_FILE bam_cutadapt/picard_cutadapt/P13204_157_S172_L001paired.md.bam.metrics -TAGGING_POLICY All -VALIDATION_STRINGENCY LENIENT -MAX_FILE_HANDLES_FOR_READ_ENDS_MAP 4000


#java -Djava.io.tmpdir=${JUNK} -jar /willerslev/software/picard.jar MarkDuplicates OPTICAL_DUPLICATE_PIXEL_DISTANCE=12000 I=bam_cutadapt/P13204_154_S169_L001paired.bam o=picard_temp/P13204_154_S169_L001paired.md.bam REMOVE_DUPLICATES=false METRICS_FILE=picard_temp/P13204_154_S169_L001paired.md.bam.metrics TAGGING_POLICY=All VALIDATION_STRINGENCY=LENIENT MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=4000

#java -XX:ParallelGCThreads=15 -Djava.io.tmpdir=picard_MD_junk -jar ~/miniconda3/envs/PS_proj/share/picard-2.23.3-0/picard.jar MarkDuplicates OPTICAL_DUPLICATE_PIXEL_DISTANCE=12000 I=mapping_temp/P13204_194_S209.pair2.truncated.gz.bam o=picard_temp/P13204_194_S209.pair2.truncated.gz.md.bam REMOVE_DUPLICATES=false METRICS_FILE=picard_temp/P13204_194_S209.pair2.truncated.gz.md.bam.metrics TAGGING_POLICY=All VALIDATION_STRINGENCY=LENIENT MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=4000