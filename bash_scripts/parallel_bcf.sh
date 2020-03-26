#!/bin/bash

## Make the output directory
##mkdir bcfs

## run a loop to run the bcf analysis per scaffold and save to a bcf file 
for scaf in `seq 0 209377`
do
	echo "bcftools mpileup -Ob -f ref_genome_PS/Psic_sn201_all.ph.fasta -b bam_list.txt -r $scaf -o bcfs/$scaf.bcf"
done|parallel -j14


### Create vcfs from the bcf files
for i in bcfs/*.bcf
do
	echo "bcftools call ${i} -mv -Oz -o variants/PS_variants.${i}.vcf.gz"
done