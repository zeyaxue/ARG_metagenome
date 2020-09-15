#!/bin/bash 

cd /share/lemaylab-backedup/databases/CAZy
wget http://bcb.unl.edu/dbCAN2/download/CAZyDB.07312019.fa 
wget http://bcb.unl.edu/dbCAN2/download/Databases/CAZyDB.07312019.fam-activities.txt
wget http://bcb.unl.edu/dbCAN2/download/Databases/CAZyDB.07312019.fam.subfam.ec.txt
wget http://bcb.unl.edu/dbCAN2/download/Databases/CAZyDB.07302020.fam-activities.txt


# Formate the database for diamond
# Followed scripts from: https://github.com/transcript/samsa2/blob/master/bash_scripts/DIAMOND_example_script.bash
# More on DIAMOND: https://github.com/bbuchfink/diamond

# setting general variables:
diamond_location=/share/lemaylab-backedup/milklab/programs/diamond
cazydb=/share/lemaylab-backedup/databases/CAZy/CAZyDB.07312019.fa

# --in: Path to the input protein reference database file in FASTA format
# --db: Path to the output DIAMOND database file.
$diamond_location makedb --in $cazydb --db /share/lemaylab-backedup/databases/CAZy/CAZyDB.07312019

python /share/lemaylab-backedup/milklab/michelle/functional_db_comparison/Code/python_scripts/get_all_families_mlt.py -db $cazydb -O /share/lemaylab-backedup/databases/CAZy/CAZy_family_names.tsv

python /share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/get_all_CAZy_ids.py -db $cazydb -O /share/lemaylab-backedup/databases/CAZy/CAZy_id.tsv

# calculate the length of the amino acid sequences
awk '/^>/{if (l!="") print l; print; l=0; next}{l+=length($0)}END{print l}' $cazydb | paste - - | sed 's/>//g' >> /share/lemaylab-backedup/databases/CAZy/CAZyDB.07312019.len.txt


### I found that there are duplicate reads in the CAZy database during the RPKG analysis 
## remove duplicated reads by exact match only 
##module load java bbmap
##dedupe.sh in=$cazydb out=/share/lemaylab-backedup/databases/CAZy/CAZyDB.07312019_dedupe.fa ac=f outd=duplicates.fa
###SHOULD NOT USE DEDUPE.SH BECAUSE IT BIOLOGICALLY POSSIBLE THAT SOME OF THE SEQUENCES ARE THE SAME BETWEEN ORGANISMS
###INSTEAD, I SHOULD USE METHOD TO REMOVE BASED ON HEADER ONLY

# get the list of all headers
grep ">" $cazydb > /share/lemaylab-backedup/databases/CAZy/all_headers.txt
# get the list of repeated headers
sort /share/lemaylab-backedup/databases/CAZy/all_headers.txt | uniq -d > /share/lemaylab-backedup/databases/CAZy/repeated_headers.txt
# get uniq headers (keep only one copy of the repeated headers)
sort /share/lemaylab-backedup/databases/CAZy/all_headers.txt | uniq > /share/lemaylab-backedup/databases/CAZy/unique_headers.txt

# https://www.biostars.org/p/230686/
# https://jgi.doe.gov/data-and-tools/bbtools/bb-tools-user-guide/dedupe-guide/
# https://github.com/BioInfoTools/BBMap/blob/master/sh/dedupe.sh
module load java bbmap
dedupe.sh in=$cazydb out=/share/lemaylab-backedup/databases/CAZy/CAZyDB.07312019.uniq.fa ac=f requirematchingnames

# re-calculate length
awk '/^>/{if (l!="") print l; print; l=0; next}{l+=length($0)}END{print l}' /share/lemaylab-backedup/databases/CAZy/CAZyDB.07312019.uniq.fa | paste - - | sed 's/>//g' >> /share/lemaylab-backedup/databases/CAZy/CAZyDB.07312019.uniq.len.txt

# re-make database
$diamond_location makedb --in /share/lemaylab-backedup/databases/CAZy/CAZyDB.07312019.uniq.fa --db /share/lemaylab-backedup/databases/CAZy/CAZyDB.07312019.uniq

# Download the non-redundant version of the database to compare with my own uniq read version
# https://github.com/linnabrown/run_dbcan/issues/35
wget http://bcb.unl.edu/dbCAN2/download/CAZyDB.07312019.fa.nr
