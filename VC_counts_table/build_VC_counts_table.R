### R libraries
.libPaths('/groups/umcg-lld/tmp03/umcg-agulyaeva/R_LIB')
library('optparse')
sessionInfo()



### R functions
source('function_aggregate_by_VC.R')



### input parameters
option_list = list(
	make_option('--contig_counts_file'),
	make_option('--vcontact_gbg_file'),
	make_option('--out_file'))
opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser)



### read data
cgT <- read.table(
			opt$contig_counts_file,
			header = TRUE,
			row.names = 1,
			stringsAsFactors = FALSE)


gbg <- read.csv(opt$vcontact_gbg_file, stringsAsFactors=FALSE)
idx <- which(gbg$VC != '')
gbg$VC[idx] <- paste0('VC_', gbg$VC[idx])



### sum counts per VC per sample
vcT <- aggregate_by_VC(cgT, gbg)



### write VC counts table
write.table(
	vcT,
	sep = '\t',
	row.names = FALSE,
	quote = FALSE,
	file = opt$out_file)
