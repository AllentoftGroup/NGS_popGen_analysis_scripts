#!/bin/bash

bcftools mpileup -Ou -f ref_genome_PS/Psic_sn201_all.ph.fasta -b bam_list.txt | bcftools call -mv -Oz -o variants/PS_variants.vcf.gz
bcftools index variants/PS_variants.vcf.gz


##thorfinn draft for parallelising
