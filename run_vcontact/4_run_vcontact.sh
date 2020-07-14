#!/bin/bash
#SBATCH --job-name=job4
#SBATCH --output=job4.out
#SBATCH --error=job4.err
#SBATCH --mem=20gb
#SBATCH --time=20:00:00
#SBATCH --cpus-per-task=20
#SBATCH --export=NONE
#SBATCH --get-user-env=L


# load software packages
module load Anaconda3
module list


# data files
prot_fa='GFD_crAss249_protein_products.fasta'     # protein sequemves
g2g_csv='GFD_crAss249_protein_products.g2g.csv'   # protein-to-contig mapping file


# run vConTACT
source activate '/groups/umcg-lld/tmp03/umcg-agulyaeva/CONDA/envs/vConTACT2'
conda list

vcontact \
	--raw-proteins ${prot_fa} \
	--proteins-fp ${g2g_csv} \
	--db 'ProkaryoticViralRefSeq97-Merged' \
	--output-dir 'vcontact_output' \
	--c1-bin '/groups/umcg-lld/tmp03/umcg-agulyaeva/CONDA/cluster_one-1.0.jar' \
	--threads 20

conda deactivate
