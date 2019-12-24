#!/bin/bash

cd /share/lemaylab-backedup/milklab/database/refseq/bacteria
refseq=/share/lemaylab-backedup/milklab/database/refseq

## download all bacterial assembly info from refseq 
#wget ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/assembly_summary.txt
#
## get these sequences in refseq
## https://www.biostars.org/p/61081/
#awk -F "\t" '$11=="latest"{print $20}' assembly_summary.txt > ftpdirpaths
## get only the fasta file 
#awk 'BEGIN{FS=OFS="/";filesuffix="genomic.fna.gz"}{ftpdir=$0;asm=$10;file=asm"_"filesuffix;print ftpdir,file}' ftpdirpaths > ftpfilepaths
#
#wget -i ftpfilepaths

# get the check sums files check sum
#awk 'BEGIN{FS=OFS="/";filesuffix="md5checksums.txt"}{ftpdir=$0;file=filesuffix;print ftpdir,file}' ftpdirpaths > ftpmd5paths
# get all the checksums to a single file 
#wget -i ftpmd5paths -O checksums_refseq.txt
# perform checksum of dowloaded files
for file in *_genomic.fna.gz
do
	md5sum $file >> checksums_downloads.txt
done
# download the check sum from NCBI
wget -i ftpmd5paths -O checksums_refseq.txt  &> log_checksum_refseq.txt                                                                                     
# I compared the downloaded files' checksums and the refseq checksums in jupyter notebook "" and there are non different


