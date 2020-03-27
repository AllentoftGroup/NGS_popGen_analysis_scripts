
#the directory with all the bam files 
IN=${1}
#set the directory where to save all the results
OUT=/science/willerslev/users-shared/science-snm-willerslev-rlw363/samtools_summary_merged

#create a new directory for the the files that will be created
if [[! -f "${OUT}" ]]
then
	mkdir -p ${OUT}
fi

#run the samtools to get the number of reads mapped for each bam file and save it into a txt file
for i in picard_comb/*.bam
do
	echo "samtools flagstat ${i} > samtools_summary_merged/`basename ${i}|cut -f1-2 -d.`"_summary.txt""
done


#run the count of reads mapped per position and save into a csv file
for i in ${IN}/*.bam
do
	echo $(/willerslev/software/samtools/samtools mpileup ${i}|cut -f4|sort -n|uniq -c > ${OUT}/`basename ${i}|cut -f1-2 -d.`"_coverage.csv")
done

#run an R script that extracts the values of reads and duplicates from the first type of file into a table that has the names of the sample, the original name of the sample (KXX or MXX) whether it's pod Kopista (K) or Pod Mercaru (M) and saves this table into an RDS
Rscript /science/willerslev/users-shared/science-snm-willerslev-rlw363/summary_stat_PS_mapping.R

# In the same R script read each table from the second sametool run and calculate the weighted average for each sample to find out the coverage. Put the result into a table that has the sample name, the original sample name, the island it's from, and the weighted average. Save the table into an RDS.

