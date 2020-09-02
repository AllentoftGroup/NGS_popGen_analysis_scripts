#!/bin/bash


for i in ~/sharedhome/picard_comb/*.bam
do
	echo ${i}
	samtools sort -o ~/sharedhome/sorted_bam/`basename ${i}|cut -f1-3 -d"_"`_merged_sorted.bam ${i}
done
