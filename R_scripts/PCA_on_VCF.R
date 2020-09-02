#load the library
library("SNPRelate")
#create an object with the name of the vcf file
vcf.fn<-"~/sharedhome/all_vcf_merged_PS.vcf.gz"
#convert it to a gds file with only biallelic sites
snpgdsVCF2GDS(vcf.fn, "~/sharedhome/PS_vcf.gds",  method="biallelic.only")
#read it into R
genofile <- openfn.gds("PS_vcf.gds")
#run the PCA
ccm_pca<-snpgdsPCA(genofile)
#save the object
saveRDS(ccm_pca,file = "PS_pca_SNPRelate.rds")