 #!/bin/bash

 # Followed scripts from: https://github.com/transcript/samsa2/blob/master/bash_scripts/DIAMOND_example_script.bash
 # More on DIAMOND: https://github.com/bbuchfink/diamond

 ####################################################################

# setting general variables:
diamond_location=/share/lemaylab-backedup/milklab/programs/diamond
dna2aa_py_location=/share/lemaylab-backedup/Zeya/scripts/gitSRC/ARG_metagenome/DNAtoAA_transcription_translation.py

####################################################################

# Make database with amino acid sequences
resfinder_dir=/share/lemaylab-backedup/milklab/database/resfinder_db-3.2_Oct2019

mkdir /share/lemaylab-backedup/milklab/database/resfinder_db-3.2_Oct2019/resfinder_aa
resfinder_aa_dir=/share/lemaylab-backedup/milklab/database/resfinder_db-3.2_Oct2019/resfinder_aa
 
for file in $resfinder_dir/*fsa
do
	echo Now translating  "$file"
	STEM=$(basename "$file" .fsa)

	$dna2aa_py_location $file $resfinder_aa_dir/${STEM}.faa	
done

# format database for diamond 
# write a loop to format database for each category 
## I did not concatenate all the fasta files becuase some genes can be present in multiple categories
mkdir /share/lemaylab-backedup/milklab/database/resfinder_db-3.2_Oct2019/resfinder_diamond
resfinder_diamond_dir=/share/lemaylab-backedup/milklab/database/resfinder_db-3.2_Oct2019/resfinder_diamond

for file in $resfinder_aa_dir/*faa
do 
	echo Now formatting "$file"
	STEM=$(basename "$file" .faa)

	# --in: Path to the input protein reference database file in FASTA format
	# --db: Path to the output DIAMOND database file.
	$diamond_location makedb --in $file --db $resfinder_diamond_dir/${STEM}
done	