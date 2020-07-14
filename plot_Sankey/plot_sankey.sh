#!/bin/bash
#SBATCH --job-name=job1
#SBATCH --output=job1.out
#SBATCH --error=job1.err
#SBATCH --mem=4gb
#SBATCH --time=00:30:00
#SBATCH --cpus-per-task=1
#SBATCH --export=NONE
#SBATCH --get-user-env=L


### load modules
module load R/3.5.1-foss-2015b-bare
module list


### run R script
Rscript plot_sankey.R \
	--metadata_file '../from_Resilio/GFD_metadata_short.txt' \
	--cg_counts_file '../from_Resilio/RPKM_counts_GFD.txt' \
	--vc_counts_file '../VC_counts_table/VC_read_counts.txt'
