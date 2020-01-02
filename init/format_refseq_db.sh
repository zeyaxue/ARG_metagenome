#!/bin/bash

refseq=/share/lemaylab-backedup/milklab/database/refseq

# for loop to unzip all gz file to fastq in one file 
for file in $refseq/bacteria/*_genomic.fna.gz
do
	STEM=$(basename "$file" .gz)
	gunzip -c "$file" > $refseq/bacteria/"$STEM"
done

# Concatenate all files together (I cant use cat because the file list is too long)
cd $refseq
find ./bacteria -maxdepth 1 -type f -name '*.fna' -print0 | sort -zV | xargs -0 cat > refseq_all_bacteria.fna

# Download the accession to taxid file and format for the makeblastdb taxidmap file
wget https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/accession2taxid/nucl_wgs.accession2taxid.gz
gunzip -c nucl_wgs.accession2taxid.gz | sed 1d | cut -f 2,3 > nucl_wgs_taxidmap.txt
# Modify the taxid map for blastn (I found this out after several days of debugging taxator with blastn)
awk '$0="ref|"$0' nucl_wgs_taxidmap.txt > nucl_wgs_taxidmap_blastn.txt # add "ref|" before each sequence ID
sed -e 's/\t/|\t/' nucl_wgs_taxidmap_blastn.txt > nucl_wgs_taxidmap_blastn2.txt
rm nucl_wgs_taxidmap_blastn.txt 
mv nucl_wgs_taxidmap_blastn2.txt nucl_wgs_taxidmap_blastn.txt
# Remove the zipped file
rm nucl_wgs.accession2taxid.gz

######## Format taxonomy for use with taxator
######## https://github.com/fungs/taxator-tk/issues/51
#######/share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/taxknife -f 2 --mode traverse -r species genus family order class phylum superkingdom < $refseq/#######nucl_wgs_taxidmap.txt > $refseq/nucl_wgs_taxidmap_fixed.tax
########Could not find node with taxid 97139 in the taxonomy, skipping record.
########Could not find node with taxid 2316086 in the taxonomy, skipping record.
########Could not find node with taxid 1980920 in the taxonomy, skipping record.
########Could not find node with taxid 2219060 in the taxonomy, skipping record.
########Could not find node with taxid 2249421 in the taxonomy, skipping record.
########Could not find node with taxid 2259589 in the taxonomy, skipping record.
########Could not find node with taxid 2283631 in the taxonomy, skipping record.
########Could not find node with taxid 342634 in the taxonomy, skipping record.
########Could not find node with taxid 2480581 in the taxonomy, skipping record.
########Could not find node with taxid 2487136 in the taxonomy, skipping record.
########Could not find node with taxid 2487135 in the taxonomy, skipping record.
########Could not find node with taxid 2491022 in the taxonomy, skipping record.
########Could not find node with taxid 2500534 in the taxonomy, skipping record.
########Could not find node with taxid 2516558 in the taxonomy, skipping record.
########Could not find node with taxid 2563603 in the taxonomy, skipping record.
########Could not find node with taxid 1705700 in the taxonomy, skipping record.
########Could not find node with taxid 2591007 in the taxonomy, skipping record.



# Format database for blast 
cd $refseq
/software/blast/2.9+/lssc0-linux/bin/makeblastdb -in refseq_all_bacteria.fna -dbtype nucl -parse_seqids -taxid_map nucl_wgs_taxidmap_blastn.txt -logfile log_blastn_makedb.txt -out blastdb_bacrefseq -blastdb_version 5 -title "blastdb_bacrefseq"

# Download taxdump files 
wget ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz
tar xvzf taxdump.tar.gz
 



#######################################################################################################################
# Format db for last
/software/last/621/x86_64-linux-ubuntu14.04/bin/lastdb /share/lemaylab-backedup/milklab/database/refseq/lastdb_bacrefseq /share/lemaylab-backedup/milklab/database/refseq/refseq_all_bacteria.fna


