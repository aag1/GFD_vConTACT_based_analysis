#!/bin/bash
#SBATCH --job-name=job1
#SBATCH --output=job1.out
#SBATCH --error=job1.err
#SBATCH --mem=10gb
#SBATCH --time=0:10:00
#SBATCH --cpus-per-task=1
#SBATCH --export=NONE
#SBATCH --get-user-env=L



# load software packages
module load seqtk
module list



# copy FASTA file with protein content of contigs >= 1000 nt
prot_fa_orig=/groups/umcg-lld/tmp03/umcg-sgarmaeva/GFD/GFD_all/Roux_analysis/pVOGs/nonredundant_contigs.min1000.AA.fasta
cp -p ${prot_fa_orig} .
prot_fa=$(basename ${prot_fa_orig})



# list of viral contigs after the 75% coverage filter
sed '1d' ../from_Resilio/RPKM_counts_GFD.txt |
cut -d$'\t' -f1 \
> viral_contig_ids.txt



# create FASTA file with proteins of viral contigs only
prot_fa_vir=${prot_fa%.fasta}'.viral.fasta'

grep '>' ${prot_fa} |
cut -d ' ' -f 1 |
sed 's/^>//' |
grep -F -f viral_contig_ids.txt \
> viral_protein_ids.txt

seqtk subseq ${prot_fa} viral_protein_ids.txt > ${prot_fa_vir}



# create gene-to-genome mapping file
g2g_csv=${prot_fa_vir%.fasta}'.g2g.csv'

echo 'protein_id,contig_id,keywords' > ${g2g_csv}

grep '>' ${prot_fa_vir} |
cut -d ' ' -f 1 |
perl -pe 's/^>(.+)(_[0-9]+)$/\1\2,\1,None_provided/' \
>> ${g2g_csv}
