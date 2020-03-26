#!/bin/bash

PRE=${1}

R0=${PRE}.collapsed.gz.md.bam

R2=${PRE}.pair2.truncated.gz.md.bam


samtools merge picard_comb/`basename ${PRE}_merged.gz.md.bam` ${R0} ${R2}