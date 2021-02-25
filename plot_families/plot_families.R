### R libraries
.libPaths('/groups/umcg-tifn/tmp01/users/umcg-agulyaeva/SOFTWARE/R_LIB')
library('optparse')
sessionInfo()




### R functions
source('function_plot_contigs_abundance.R')




### input parameters
option_list = list(
	make_option('--cg_counts_file'),
	make_option('--demovir_file'))
opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser)




### read files
cg_counts <- read.table(
				opt$cg_counts_file,
				sep = '\t',
				header = TRUE,
				row.names = 1)


dmv <- read.table(
                opt$demovir_file,
                sep = '\t',
                header = TRUE,
                row.names = 1,
                stringsAsFactors = FALSE
)
all(rownames(dmv) %in% rownames(cg_counts))




### family-based counts table
tab <- cg_counts
tab$Family <- 'Unassigned'
tab[rownames(dmv), 'Family'] <- dmv$Family_new

fm_counts <- aggregate(.~Family, data = tab, FUN = sum)

rownames(fm_counts) <- fm_counts$Family
fm_counts$Family <- NULL


M <- t(as.matrix(fm_counts))
rownames(M) <- sub('^GFD_', '', rownames(M))
M <- M[order(as.numeric(rownames(M))), ]


fam_ord <- c(
    'Picornaviridae', 'Alphaflexiviridae', 'Bromoviridae', 'Luteoviridae', 'Virgaviridae', 'Tombus-like',
    'Picobirnaviridae',
    'Circoviridae', 'Inoviridae', 'Microviridae',
    'Herpesviridae', 'Myoviridae', 'Podoviridae', 'Siphoviridae', 'CrAss-like',
    'Unassigned'
)
identical(sort(fam_ord), colnames(M))
M <- M[, fam_ord]


write.table(
	round(M, 2),
	sep = '\t',
	row.names = TRUE,
	quote = FALSE,
	file = 'Family_read_counts.txt'
)




### plot coverage per family
fam_font <- ifelse(fam_ord %in% c('Tombus-like', 'CrAss-like', 'Unassigned'), 1, 3)


pdf(
    'GFD_coverage_per_family.pdf',
    width = pdf.options()$width * 1,
    height = pdf.options()$height * 1.6
)

par(mar = c(2, 3, 7, 1), ps = 10)

plot_contigs_abundance(
			M,
			sample_space = 3,
            contig_font = fam_font,
            brackets = c(0, 10^seq(0, 6, 0.1)),
			brackets_lab = c(0, 10^seq(1, 6, 1))
)

text(x = 3, y = -8, labels = '(+)ssRNA', xpd = TRUE)
lines(x = c(0.2, 5.8), y = rep(-7, 2), xpd = TRUE)

text(x = 6.5, y = -8, labels = 'dsRNA', xpd = TRUE)
lines(x = c(6.2, 6.8), y = rep(-7, 2), xpd = TRUE)

text(x = 8.5, y = -8, labels = 'ssDNA', xpd = TRUE)
lines(x = c(7.2, 9.8), y = rep(-7, 2), xpd = TRUE)

text(x = 12.5, y = -8, labels = 'dsDNA', xpd = TRUE)
lines(x = c(10.2, 14.8), y = rep(-7, 2), xpd = TRUE)

dev.off()
