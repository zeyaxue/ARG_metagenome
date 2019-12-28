#!/bin/bash 

cd /share/lemaylab-backedup/databases/CAZy
wget http://bcb.unl.edu/dbCAN2/download/CAZyDB.07312019.fa 
wget http://bcb.unl.edu/dbCAN2/download/Databases/CAZyDB.07312019.fam-activities.txt
wget http://bcb.unl.edu/dbCAN2/download/Databases/CAZyDB.07312019.fam.subfam.ec.txt


# Formate the database for diamond
# Followed scripts from: https://github.com/transcript/samsa2/blob/master/bash_scripts/DIAMOND_example_script.bash
# More on DIAMOND: https://github.com/bbuchfink/diamond

# setting general variables:
diamond_location=/share/lemaylab-backedup/milklab/programs/diamond
cazydb=/share/lemaylab-backedup/databases/CAZy/CAZyDB.07312019.fa

# --in: Path to the input protein reference database file in FASTA format
# --db: Path to the output DIAMOND database file.
$diamond_location makedb --in $file --db /share/lemaylab-backedup/databases/CAZy/CAZyDB.07312019
