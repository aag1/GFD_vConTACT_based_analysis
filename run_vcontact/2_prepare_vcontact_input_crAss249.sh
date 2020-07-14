#!/bin/bash
#SBATCH --job-name=job2
#SBATCH --output=job2.out
#SBATCH --error=job2.err
#SBATCH --mem=10gb
#SBATCH --time=0:10:00
#SBATCH --cpus-per-task=1
#SBATCH --export=NONE
#SBATCH --get-user-env=L


# get fasta
perl -pe 's/^>C[0-9]+\|/>/' \
	/groups/umcg-lld/tmp03/umcg-agulyaeva/DATA/Guerin2018_PMID30449316_SupplData/Data_S1/crass_protein_products.fasta > \
	Guerin2018_PMID30449316_crass_protein_products.fasta


# make g2g
echo 'protein_id,contig_id,keywords' > Guerin2018_PMID30449316_crass_protein_products.g2g.csv

grep '>' Guerin2018_PMID30449316_crass_protein_products.fasta |
perl -pe 's/^>(.+)(_[0-9]+)$/\1\2,\1,None_provided/' \
>> Guerin2018_PMID30449316_crass_protein_products.g2g.csv
