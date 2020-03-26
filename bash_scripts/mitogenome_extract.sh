#!/bin/bash

for f in picard_comb/*.bam
do
	echo "samtools view -h -O BAM ${f} 74455 > mitoGenome/`basename ${f}|cut -f1-2 -d.`.mito.bam"
done
