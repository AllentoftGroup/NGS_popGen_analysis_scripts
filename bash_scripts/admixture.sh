#!/bin/bash



##admixture stuff
mkdir gl_output
for scaf in `seq 0 209377`
do
echo "angsd -GL 1 -out gl_output/$scaf -P 4 -doGlf 2 -doMajorMinor 1 -SNP_pval 1e-6 -doMaf 1  -bam bam_list.txt -r $scaf"
done|parallel -j12
