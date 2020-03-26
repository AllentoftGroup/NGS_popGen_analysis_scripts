#!/bin/bash

for i in mitoGenome/*.bam
do
	echo "software_local/proovread/bin/bam2cns --bam ${i} --ref P_siculus_mitoGenome_Croatia_74455_org.fasta --prefix mitoGenome/consensus/`basename ${i}|cut -f1-3 -d_`".mito.cns""
done
