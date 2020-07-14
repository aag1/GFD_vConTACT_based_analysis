### R libraries
.libPaths('/groups/umcg-lld/tmp03/umcg-agulyaeva/R_LIB')
library('optparse')
sessionInfo()




### input parameters
option_list = list(
	make_option('--metadata_file'),
	make_option('--cg_counts_file'),
	make_option('--vc_counts_file'),
    make_option('--fm_counts_file'))
opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser)




### read files
metadata <- read.table(
				opt$metadata_file,
				sep = '\t',
				header = TRUE,
				row.names = 1)
excl <- c('GFDR2_11.3', 'GFDR2_11.7', 'GFDR_10.1',  'GFDR_10.3',  'GFDR_10.5')
metadata <- metadata[!(rownames(metadata) %in% excl), ]


cg_counts <- read.table(
				opt$cg_counts_file,
				sep = '\t',
				header = TRUE,
				row.names = 1)


vc_counts <- read.table(
				opt$vc_counts_file,
				sep = '\t',
				header = TRUE,
				row.names = 1)


fm_counts <- read.table(
				opt$fm_counts_file,
				sep = '\t',
				header = TRUE,
				row.names = 1)




### calculate
indiv <- sort(unique(metadata$Sample_real))


L <- list(
    contigs = cg_counts,
    VCs = vc_counts,
    families = fm_counts
)


for (x in names(L)) {
    
    t <- L[[x]]


    DF <- as.data.frame(
            matrix(
                    NA,
                    nrow = nrow(t),
                    ncol = length(indiv),
                    dimnames = list(rownames(t), paste0('Individual_', indiv))
            ),
            stringsAsFactors = FALSE)


    for (y in indiv) {
        
        samples <- rownames(metadata)[metadata$Sample_real == y]

        DF[, paste0('Individual_', y)] <- apply(t[, samples], 1, function (v) ifelse(any(v > 0), 1, 0))

    }


    DF$SUM <- apply(DF, 1, sum)

    N <- sum(DF$SUM > 5) / nrow(DF) * 100

    cat(N, '% of ', x, ' were shared among more than half of the individual virus pools.\n\n\n', sep='')

}
