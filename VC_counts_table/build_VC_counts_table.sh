#!/bin/bash
#SBATCH --job-name=job1
#SBATCH --output=job1.out
#SBATCH --error=job1.err
#SBATCH --mem=5gb
#SBATCH --time=00:30:00
#SBATCH --cpus-per-task=1
#SBATCH --export=NONE
#SBATCH --get-user-env=L



### load modules
module load R/3.5.1-foss-2015b-bare
module list


### run R script
Rscript build_VC_counts_table.R \
	--contig_counts_file '../from_Resilio/RPKM_counts_GFD.txt' \
	--vcontact_gbg_file '../run_vcontact/vcontact_output/genome_by_genome_overview.csv' \
	--out_file 'VC_read_counts.txt'
