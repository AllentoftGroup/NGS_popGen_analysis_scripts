for i in `ls Podarcis/SciLife/Data/Liz_DeepSeq_1/P13204/*/02-FASTQ/*/*.gz|grep R1|cut -f1-10 -d_`
do 
	bash bash_scripts/trimmomatic.sh $i
done
