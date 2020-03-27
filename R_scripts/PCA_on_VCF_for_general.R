##### Calculate the PCA (do it on the cluster#####

#otherwise you can install it locally on your home directory on the cluster using 
BiocManager::install("SNPRelate",lib = "path/to/you/directory")
#or just BiocManager::install("SNPRelate") if your local directory is the main directory where R looks for your packages
#load the library (if you have the package installed)
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


#### Principal components analysis plot and table (locally) #####
# Read the RDS that you saved
PS.pca<- readRDS("rds/PS_pca_SNPRelate.rds")

###### plot a barplot of eigenvalues ######
#save the eigenvalues as a unique matrix
PS.pca.eigv<- PS.pca$eigenval[1:22]
#create a barplot by converting the eigenvalues to percentages 
barplot(100*PS.pca.eigv/sum(PS.pca.eigv,na.rm = T), col = heat.colors(50), main="PCA Eigenvalues")
#give it titles
title(ylab="Percent of variance\nexplained", line = 2)
title(xlab="Eigenvalues", line = 1)


###### Cumulative variation that is explained by the PC axis #####
#take the first 6 eigenvalues and calculate the cumulatinve variation
prec.pc<- head(cumsum(100*PS.pca.eigv/sum(PS.pca.eigv,na.rm = T)))
#add colnames to them
pc.names<- c("pc1","pc2","pc3","pc4","pc5","pc6")
#make it into a dataframe
pc.eig<- data.frame(PC_axis = pc.names,Cumulative_proportion = prec.pc)
#print it as a nice table 
knitr::kable(pc.eig)

###### Preper the data for the PC plot #####
# create a data frame from the PCA scores
# convert the eigenvalues into a dataframe
PS.pca.scores <- as.data.frame(PS.pca$eigenvect)
#add a population column - here I took it from the gl file I created before, but you can just take it from oyur idividual-population dataset you have. Number of eigenvalues is equal to the number of individuals you had in your vcf and the order is the same as in the vcf
PS.pca.scores$pop <- pop(gl.PS)

##### plot the PCA ######
#plot the first 2 PC's. Change the labs to represent the values for your PC axis
pc1<- ggplot(PS.pca.scores, aes(x=V1, y=V2, colour=pop,label = ind)) +
  geom_point(size=2)+
  stat_ellipse(level = 0.95, size = 1)+
  scale_color_manual(values = cols.ps) +
  geom_hline(yintercept = 0)+
  geom_vline(xintercept = 0)+
  labs(x = "PC1 (12.6%)", y = "PC2 (9.8%)")+
  theme_bw()
pc1
