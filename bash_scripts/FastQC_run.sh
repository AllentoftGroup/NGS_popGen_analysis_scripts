#!/bin/bash

# define the path to the program that we are going to use
PRG=/willerslev/software/FastQC/fastqc

# run a loop to open each of the folders in the specific path and run the program on it
for i in  Podarcis/SciLife/Data/Liz_DeepSeq_1/P13204/P13204_1*/*/*/*.gz
do
    echo ${PRG} ${i} -o html_reports
done
