#!/bin/bash
#SBATCH --job-name=job1
#SBATCH --output=job1.out
#SBATCH --error=job1.err
#SBATCH --mem=10gb
#SBATCH --time=00:30:00
#SBATCH --cpus-per-task=1
#SBATCH --export=NONE
#SBATCH --get-user-env=L
#SBATCH --qos=dev


### load modules
module load R/3.5.1-foss-2015b-bare
module list


### run R script
Rscript plot_families.R \
	--cg_counts_file '../from_Resilio/RPKM_counts_GFD.txt' \
    --demovir_file '../VC_taxo_extension/Contigs_metadata_new.txt'
