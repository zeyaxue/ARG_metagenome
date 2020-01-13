#!/bin/bash

# DIAMOND
diamond_location=/share/lemaylab-backedup/milklab/programs/diamond
db=/share/lemaylab-backedup/databases/CAZy/CAZyDB.07312019.dmnd

####################################################################
#
# Align to CAZy database with diamond
# for diamond usage, read manual: https://github.com/bbuchfink/diamond

output_dir_flash=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step4_flash
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/CAZy_diamond
output_dir_diamond=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/CAZy_diamond

for file in $output_dir_flash/*.extendedFrags.fastq
do
	STEM=$(basename "$file" .extendedFrags.fastq)

	# eval chosen based on recommendations for 200-250bp reads
	$diamond_location blastx --db $db -q $file -a $output_dir_diamond/${STEM}.daa -t ./ -k 1 --sensitive --evalue 1e-25
	$diamond_location view --daa $output_dir_diamond/${STEM}.daa -o $output_dir_diamond/${STEM}.txt -f tab	
done