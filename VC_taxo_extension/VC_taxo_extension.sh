#!/bin/bash
#SBATCH --job-name=job1
#SBATCH --output=job1.out
#SBATCH --error=job1.err
#SBATCH --mem=1gb
#SBATCH --time=00:10:00
#SBATCH --cpus-per-task=1
#SBATCH --export=NONE
#SBATCH --get-user-env=L
#SBATCH --qos=dev



### load modules
module load R/3.5.1-foss-2015b-bare
module list



### run R script
Rscript VC_taxo_extension.R \
    --gbgF '../run_vcontact/vcontact_output/genome_by_genome_overview.csv' \
    --datF '../from_Resilio/Contigs_metadata.txt'
