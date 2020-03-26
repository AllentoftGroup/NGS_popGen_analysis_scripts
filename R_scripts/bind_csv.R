library(tidyverse)
my.csv.files<- list.files(path = "~/sharedhome/samtool_summary",pattern = "*\\.csv",full.names = T)
my.csv.files.names<- list.files(path = "~/sharedhome/samtool_summary",pattern = "*\\.csv",full.names = F)
cov_data_base<- read_csv("samtool_summary/P13204_101_S116.collapsed_coverage.csv",col_names = F) %>% 
  separate(col = X1,into = c("loc_total","read_num"),sep = " ") %>% 
  type_convert() %>% 
  add_column(sample_name = "P13204_101_S116", data_type = "collapsed")
for(i in 2:length(my.csv.files)){
  cov_data<- read_csv(my.csv.files[i],col_names = F) %>% 
    separate(col = X1,into = c("loc_total","read_num"),sep = " ") %>% 
    type_convert() %>% 
    add_column(sample_name = word(my.csv.files.names[i],1,sep="\\."),data_type = str_extract(my.csv.files.names[i],"[A-z]+.(?=_)"))
  cov_data_base<- bind_rows(cov_data_base,cov_data)
}

write_csv(cov_data_base,"cov_data_for_all_samples.csv")