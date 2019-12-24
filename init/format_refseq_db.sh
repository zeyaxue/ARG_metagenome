#!/bin/bash

refseq=/share/lemaylab-backedup/milklab/database/refseq

# for loop to unzip all gz file to fastq in one file 
for file in $refseq/bacteria/*_genomic.fna.gz
do
	STEM=$(basename "$file" .gz)
	gunzip -c "$file" > $refseq/bacteria/"$STEM"
done

cat $refseq/bacteria/*.fna > $refseq/refseq_all_bacteria.fna

# Download the accession to taxid file and format for the makeblastdb taxidmap file
wget https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/accession2taxid/nucl_wgs.accession2taxid.gz
gunzip -c nucl_wgs.accession2taxid.gz | sed 1d | cut -f 2,3 > nucl_wgs_taxidmap.txt
rm nucl_wgs.accession2taxid.gz
# Format taxonomy for use with taxator
# https://github.com/fungs/taxator-tk/issues/51
/share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/taxknife -f 2 --mode traverse -r species genus family order class phylum superkingdom < $refseq/nucl_wgs_taxidmap.txt > $refseq/nucl_wgs_taxidmap_fixed.tax
#Could not find node with taxid 97139 in the taxonomy, skipping record.
#Could not find node with taxid 2316086 in the taxonomy, skipping record.
#Could not find node with taxid 1980920 in the taxonomy, skipping record.
#Could not find node with taxid 2219060 in the taxonomy, skipping record.
#Could not find node with taxid 2249421 in the taxonomy, skipping record.
#Could not find node with taxid 2259589 in the taxonomy, skipping record.
#Could not find node with taxid 2283631 in the taxonomy, skipping record.
#Could not find node with taxid 342634 in the taxonomy, skipping record.
#Could not find node with taxid 2480581 in the taxonomy, skipping record.
#Could not find node with taxid 2487136 in the taxonomy, skipping record.
#Could not find node with taxid 2487135 in the taxonomy, skipping record.
#Could not find node with taxid 2491022 in the taxonomy, skipping record.
#Could not find node with taxid 2500534 in the taxonomy, skipping record.
#Could not find node with taxid 2516558 in the taxonomy, skipping record.
#Could not find node with taxid 2563603 in the taxonomy, skipping record.
#Could not find node with taxid 1705700 in the taxonomy, skipping record.
#Could not find node with taxid 2591007 in the taxonomy, skipping record.



# Format database for blast 
/software/blast/2.9+/lssc0-linux/bin/makeblastdb -in $refseq/refseq_all_bacteria_test100.fna -dbtype nucl -parse_seqids -taxid_map $refseq/nucl_wgs_taxidmap.txt -logfile log_makedb.txt -out $refseq/blastdb_test100
#Building a new DB, current time: 12/23/2019 00:07:42
#New DB name:   /share/lemaylab-backedup/milklab/database/refseq/blastdb_test100
#New DB title:  /share/lemaylab-backedup/milklab/database/refseq/refseq_all_bacteria_test100.fna
#Sequence type: Nucleotide
#Keep MBits: T
#Maximum file size: 1000000000B



# Dowload NCBI database in the same directory as database for the look-up to work with blastn/blastp/blastx
#cd $refseq
#wget ftp://ftp.ncbi.nlm.nih.gov/blast/db/taxdb.tar.gz
#tar xvzf taxdb.tar.gz 

# Down load taxdump files 
#wget ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz
#tar xvzf taxdump.tar.gz


#######################################################################################################################
# Download an example of taxator tax id mapping file
wget https://nextcloud.bifo.helmholtz-hzi.de/s/kgtfteoQ9LfzQZx/download?path=%2F&files=nonredundant-microbial_20121122.tar.xz
# However, the downloaded the xz 


#######################################################################################################################
# run a test 
# /software/blast/2.9+/lssc0-linux/bin/blastn -db blastdb_test100 -query query_test.fna  -outfmt "10 qseqid sseqid pident staxids sscinames scomnames sblastnames sskingdoms"
####### It worked! output: jejeju,ref|NZ_NFNG01000029.1|,100.00,197,Campylobacter jejuni,Campylobacter jejuni,e-proteobacteria,Bacteria






#######################################################################################################################
# Format db for last
/software/last/621/x86_64-linux-ubuntu14.04/bin/lastdb /share/lemaylab-backedup/milklab/database/refseq/refseq_all_bacteria_test100_last /share/lemaylab-backedup/milklab/database/refseq/refseq_all_bacteria_test100.fna


#######################################################################################################################
# Generate hashes for bbsketch



#######Didn't use for fear of home directory time out
#export PATH="/home/xzyao/miniconda3/bin:$PATH"
#export PATH="/home/xzyao/.local/bin:$PATH"
#source activate ARG-py37
#ncbi-genome-download bacteria --parallel 20 -s refseq --format fasta,assembly-report -o /share/lemaylab-backedup/milklab/database/


#http://www.verdantforce.com/2014/12/building-blast-databases-with-taxonomy.html