#!/bin/bash

#index the bam files

for f in mitoGenome/*.bam
do
    echo samtools index ${f}
done
