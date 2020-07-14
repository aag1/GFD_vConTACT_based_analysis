#!/bin/bash
#SBATCH --job-name=job3
#SBATCH --output=job3.out
#SBATCH --error=job3.err
#SBATCH --mem=10gb
#SBATCH --time=0:10:00
#SBATCH --cpus-per-task=1
#SBATCH --export=NONE
#SBATCH --get-user-env=L


cat nonredundant_contigs.min1000.AA.viral.fasta > GFD_crAss249_protein_products.fasta
cat Guerin2018_PMID30449316_crass_protein_products.fasta >> GFD_crAss249_protein_products.fasta


cat nonredundant_contigs.min1000.AA.viral.g2g.csv > GFD_crAss249_protein_products.g2g.csv
sed '1d' Guerin2018_PMID30449316_crass_protein_products.g2g.csv >> GFD_crAss249_protein_products.g2g.csv
