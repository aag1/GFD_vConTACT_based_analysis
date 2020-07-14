aggregate_by_VC <- function (cgT, gbg) {

	### add 'VC' column to the contigs counts table
	cgT$VC <- sapply(rownames(cgT), function (x) {

				idx <- which(gbg$Genome==x)

				VC <- gbg$Genome[idx]

				if (gbg$VC.Status[idx] %in% c('Clustered','Clustered/Singleton')) { VC <- gbg$VC[idx] }

				return(VC)

	})


	### make VC counts table by summation of counts per VC per sample
	vcT <- aggregate(.~VC, data = cgT, FUN = sum)


	### return VC table
	return(vcT)

}
