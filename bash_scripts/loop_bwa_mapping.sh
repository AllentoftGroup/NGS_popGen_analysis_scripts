#!/bin/bash

for i in `ls cutadapt/trimed_15/*.gz|grep R1|cut -f1-5 -d_`
do 
	bash bash_scripts/bwa_mem_podarcis_cutadapt.sh $i bam_cutadapt
done