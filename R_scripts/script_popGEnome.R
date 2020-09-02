GENOME.classes <- parallel::mclapply(as.list(data.split.l),
                                     function(x){
                                       From <- as.numeric(strsplit(x[[1]],"-")[[1]][1])
                                       To <- as.numeric(strsplit(x[[1]],"-")[[1]][2])
                                       return(readVCF(
                                         filename="~/sharedhome/test_dir/sparrow_chr8_downsample.vcf.gz",
                                         numcols=1000, tid=x[[2]], frompos=From, topos=To, samplenames=NA,
                                         gffpath=FALSE, include.unknown=TRUE,
                                         approx=FALSE, out=x[[1]], parallel=FALSE))
                                     },
                                     mc.cores = 1, mc.silent = TRUE, mc.preschedule = TRUE)
