### R libraries
.libPaths('/groups/umcg-lld/tmp03/umcg-agulyaeva/R_LIB')
library('optparse')
library('dplyr')
library('alluvial')
sessionInfo()




### R functions
source('function_plot_sankey.R')
plot_sankey




### input parameters
option_list = list(
	make_option('--metadata_file'),
	make_option('--cg_counts_file'),
	make_option('--vc_counts_file'))
opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser)




### read files
excl <- c('GFDR2_11.3', 'GFDR2_11.7', 'GFDR_10.1',  'GFDR_10.3',  'GFDR_10.5', 'GFD_10.1',  'GFD_10.3',  'GFD_10.5')


metadata <- read.table(
				opt$metadata_file,
				sep = '\t',
				header = TRUE,
				row.names = 1)
metadata <- metadata[!(rownames(metadata) %in% excl), ]


cg_counts <- read.table(
				opt$cg_counts_file,
				sep = '\t',
				header = TRUE,
				row.names = 1)
cg_counts <- cg_counts[, !(colnames(cg_counts) %in% excl)]


vc_counts <- read.table(
				opt$vc_counts_file,
				sep = '\t',
				header = TRUE,
				row.names = 1)
vc_counts <- vc_counts[, !(colnames(vc_counts) %in% excl)]




### vectors & function
PAL <- c('lightcoral', 'lightblue', 'lightblue4', 'grey50')
names(PAL) <- c('(50,100]', '(0,50]', 'Unique', 'Absent')


STATE <- c('Before_GFD', 'GFD', 'After_GFD')


assign_bracket <- function (num_smpl, pct_smpl) {

	brk <- NA
	if (num_smpl == 0)                  { brk <- 'Absent'   }
	if (num_smpl == 1)                  { brk <- 'Unique'   }
	if (num_smpl > 1 & pct_smpl <= 50)  { brk <- '(0,50]'   }
	if (num_smpl > 1 & pct_smpl > 50)   { brk <- '(50,100]' }
	return(brk)

}




### list with count tables
L <- list(
		cg_counts,
		vc_counts
)


L <- lapply(L, function (df) {

		for (i in seq_along(STATE)) {

			smpl <- rownames(metadata)[metadata$timepoint == i]

			colName1 <- paste0('num_smpl_', STATE[i])
			df[,colName1] <- sapply(1:nrow(df), function (j) sum(df[j, smpl] > 0))

			colName2 <- paste0('pct_smpl_', STATE[i])
			df[,colName2] <- df[,colName1] / length(smpl) * 100

            colName3 <- paste0('brk_smpl_', STATE[i])
			df[,colName3] <- sapply(1:nrow(df), function (j) assign_bracket(df[j,colName1], df[j,colName2]))

		}

		# remove contigs specific to individual #10
		bad <- apply(df[, paste0('num_smpl_', STATE)], 1, function (v) all(v == 0))
		df <- df[!bad, ]

		return(df)

})




### plot Sankey diagram
for (i in 1:2) {

    Sys.sleep(10)

	pdf(
		paste0('GFD_', ifelse(i==1, 'contigs', 'VCs'), '_sankey.pdf'),
        width = pdf.options()$width * 1,
        height = pdf.options()$height * 1.2
	)

	plot_sankey(L[[i]], STATE, PAL)

	dev.off()

}


save(L, STATE, PAL, file = 'gfd_sankey_data.RData')
