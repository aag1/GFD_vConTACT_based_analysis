# uses packages 'dplyr' & 'alluvial'


plot_sankey <- function (df, STATE, PAL) {


    S <- setNames(c('D', 'C', 'B', 'A'), c('(50,100]', '(0,50]', 'Unique', 'Absent'))
    names(PAL) <- S[names(PAL)]


	# prepare data
	cols <- paste0('brk_smpl_', STATE)
	df <- df[, cols]

    for (x in cols) {
        df[,x] <- S[df[,x]]
    }

	allu_data <- df %>%
				 group_by_all() %>%
				 summarise(freq = n())

	allu_data <- as.data.frame(allu_data)


	# plot
	sele <- unlist(allu_data[, 1])

	allu_plot <- alluvial(
					allu_data[, cols],
					freq = allu_data$freq,
					axis_labels = gsub('_', ' ', STATE),
					col = PAL[sele],
					alpha = ifelse(sele == 'D', 1, 0.5),
					border = sapply(sele, function (x) adjustcolor(PAL[x], alpha.f = ifelse(x == 'D', 1, 0))),
					gap.width = 0.05,
					cw = 0.2,
					cex = 10^(-6),
                    cex.axis = 1.2
	)


	# labels
	for (i in seq_along(STATE)) {

		for (b in names(PAL)) {

			colName <- paste0('brk_smpl_', STATE[i])
			idx <- which(allu_data[, colName] == b)

			N <- sum(allu_data$freq[idx])

			coo <- allu_plot$endpoints[[i]][idx, ]
			coo <- unlist(coo)
			coo <- sum(range(coo)) / 2

			text(
				labels = if (b=='C') { expression(bold(NA<='50%')) } else { if (b=='D') { '> 50%' } else { names(S)[S==b] } },
				x = i - ifelse(b == 'D', 0.1, 0),
				y = ifelse(b == 'D', 1.015, coo + 0.015),
				font = 2,
                cex = 1.25,
				xpd = TRUE
			)

			text(
				N,
				x = i + ifelse(b == 'D', 0.1, 0),
				y = ifelse(b == 'D', 1.015, coo - 0.015),
                cex = 1.25,
				xpd = TRUE
			)

		}
	}

}
