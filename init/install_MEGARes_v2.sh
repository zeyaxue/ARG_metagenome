#!/bin/bash 

cd /share/lemaylab-backedup/milklab/database

wget https://megares.meglab.org/download/megares_v2.00.zip

unzip megares_v2.00.zip

mkdir megares_v2
mv megares_* megares_v2/

# index the database for bwa
module load bwa

bwa index megares_v2/megares_modified_database_v2.00.fasta 
bwa index megares_v2/megares_drugs_database_v2.00.fasta

# caculate the gene length for all genes 
# This info is needed for MicrobeCensus normalization
cd megares_v2/

for file in *.fasta
do
	STEM=$(basename "$file" .fasta)

	source /share/lemaylab-backedup/Zeya/scripts/gitSRC/ARG_metagenome/count_fasta_length.sh \
	$file \
	${STEM}_GeneLen.txt 
done	