#!/bin/bash

# The name argument that is passed by the user
PRE=${1}

# the name of all the collapsed bam files 
R0=${PRE}.collapsed.gz.md.bam

#the naem of all the paired bam files
R2=${PRE}.pair2.truncated.gz.md.bam

# Samtools command to merge the collaped and the paired bam files to a merged one in a "picard_comb" directory
samtools merge picard_comb/`basename ${PRE}_merged.gz.md.bam` ${R0} ${R2}
