for i in `ls Podarcis/SciLife/Data/Liz_DeepSeq_1/P13204/*/02-FASTQ/*/*.gz|grep R1|cut -f1-10 -d_`
do 
	echo ./adapt_trim_podarcis.sh $i Adapt_temp
done
