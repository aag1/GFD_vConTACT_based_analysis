### R libraries
.libPaths('/groups/umcg-lld/tmp03/umcg-agulyaeva/R_LIB')
library('optparse')
sessionInfo()



### input parameters
option_list = list(
	make_option('--gbgF'),
	make_option('--datF'))
opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser)



### read data
gbg <- read.table(
        opt$gbgF,
        sep = ',',
        header = TRUE,
        row.names = 2,
        stringsAsFactors = FALSE
)

gbg <- gbg[ grep('^GFD_', rownames(gbg)), ]

idx <- which(gbg$VC == '')
gbg$VC[idx] <- NA
gbg$VC[-idx] <- paste0('VC_', gbg$VC[-idx])


dat <- read.table(
        opt$datF,
        sep = '\t',
        header = TRUE,
        row.names = 1,
        stringsAsFactors = FALSE
)


identical(sort(rownames(gbg)), sort(rownames(dat)))
cat('\n\n')



### add columns
dat$VC <- NA
dat[rownames(gbg), 'VC'] <- gbg$VC

dat$Order_new <- dat$Order
dat$Family_new <- dat$Family



# Manual order/family corrections
not_flavi <- c('GFD_5.6_NODE_3250_length_4645_cov_3.185403', 'GFD_3.1_NODE_293_length_24122_cov_12.667512')
dat[not_flavi, c('Order_new', 'Family_new')] <- 'Unassigned'

not_nido <- 'GFD_3.6_NODE_399_length_35374_cov_8.100965'
dat[not_nido, c('Order_new', 'Family_new')] <- 'Unassigned'

tombus <- c('GFD_11.7_NODE_3204_length_2878_cov_147.917109', 'GFD_14.1_NODE_11134_length_2601_cov_22.109976')
dat[tombus, 'Order_new'] <- 'no_order_Tombus-like'
dat[tombus, 'Family_new'] <- 'Tombus-like'

NCLDV_FAMILIES <- c('Poxviridae', 'Ascoviridae', 'Iridoviridae', 'Marseilleviridae', 'Mimiviridae', 'Phycodnaviridae', 'Pithoviridae')
dat$Order_new  <- sapply(dat$Order_new, function (x) ifelse(x %in% paste0('no_order_', c(NCLDV_FAMILIES, 'Baculoviridae')), 'Unassigned', x))
dat$Family_new <- sapply(dat$Family_new, function (x) ifelse(x %in% c(NCLDV_FAMILIES, 'Baculoviridae'), 'Unassigned', x))

dat$Order_1 <- dat$Order_new
dat$Family_1 <- dat$Family_new



# VC-based oredr/family assignments
for (x in unique(dat$VC[!is.na(dat$VC)])) {

    idx <- which(dat$VC == x)
    if (length(idx) == 1) { next }


    fam <- dat$Family_new[idx]
    fam <- unique(fam)
    fam <- fam[fam != 'Unassigned']
    if (length(fam) == 1) { dat$Family_new[idx] <- fam }


    ord <- dat$Order_new[idx]
    ord <- unique(ord)
    ord <- ord[ord != 'Unassigned']
    if (length(ord) == 1) { dat$Order_new[idx] <- ord }

}



### Test
# 1
v1 <- unlist(table(paste0(dat$Order, '|', dat$Family)))
v2 <- unlist(table(paste0(dat$Order_new, '|', dat$Family_new)))
n <- unique(c(names(v1), names(v2)))
m <- matrix(0, nrow = length(n), ncol = 2, dimnames = list(n, c('before', 'after')))
m <- as.data.frame(m, stringsAsFactors=FALSE)
m[names(v1), 'before'] <- v1
m[names(v2), 'after'] <- v2
m <- m[order(rownames(m)), ]
m <- m[c(which(m$before>0 & m$after>0), which(m$after==0), which(m$before==0)), ]
m
cat('\n\n')


# 2
v1 <- unlist(table(paste0(dat$Order_1, '|', dat$Family_1)))
v2 <- unlist(table(paste0(dat$Order_new, '|', dat$Family_new)))
n <- unique(c(names(v1), names(v2)))
m <- matrix(0, nrow = length(n), ncol = 2, dimnames = list(n, c('before', 'after')))
m[names(v1), 'before'] <- v1
m[names(v2), 'after'] <- v2
m <- m[order(rownames(m)), ]
write.table(m, sep = '\t', quote = FALSE, file = 'VC_extension_of_Demovir_assignments.txt')



### write table
write.table(
	dat[, !(colnames(dat) %in% c('Order_1', 'Family_1'))],
	sep = '\t',
	quote = FALSE,
	file = 'Contigs_metadata_new.txt'
)
 
warnings()
