#!/bin/bash

#cd /share/lemaylab-backedup/databases
#mkdir b-galactosidase
#cd b-galactosidase
#
#wget https://raw.githubusercontent.com/mltreiber/functional_metagenomics/master/databases/db_with_B-galac.faa

# Formate the database for diamond
# Followed scripts from: https://github.com/transcript/samsa2/blob/master/bash_scripts/DIAMOND_example_script.bash
# More on DIAMOND: https://github.com/bbuchfink/diamond

# setting general variables:
#diamond_location=/share/lemaylab-backedup/milklab/programs/diamond
bgdb=/share/lemaylab-backedup/databases/b-galactosidase/db_with_B-galac.faa
#
## --in: Path to the input protein reference database file in FASTA format
## --db: Path to the output DIAMOND database file.
#$diamond_location makedb --in $bgdb --db /share/lemaylab-backedup/databases/b-galactosidase/db_with_B-galac

python /share/lemaylab-backedup/milklab/michelle/functional_db_comparison/Code/python_scripts/get_all_families_mlt.py -db $bgdb -O /share/lemaylab-backedup/databases/b-galactosidase/B-galac_family_names.tsv