#!/bin/bash

# DIAMOND
diamond_location=/share/lemaylab-backedup/milklab/programs/diamond
diamond_db_dir=/share/lemaylab-backedup/milklab/database/resfinder_db-3.2_Oct2019/resfinder_diamond

####################################################################
#
# STEP 6: Align to resfinder database with diamond
# for diamond usage, read manual: https://github.com/bbuchfink/diamond

echo "NOW STARTING ALIGNMENT WITH DIAMOND AT: "; date

output_dir_flash=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_trim_fastuniq_flash/step4_flash
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step6_resfinder_diamond_test
output_dir_diamond=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step6_resfinder_diamond_test

for file in $output_dir_flash/*..extendedFrags.fastq
do
	STEM=$(basename "$file" ..extendedFrags.fastq)

	for db in $diamond_db_dir/*.dmnd
	do
		echo "Now starting on file " $file "with db " $db

		STEM_db=$(basename "$db" .dmnd)

		$diamond_location blastx --db $db -q $file -a $output_dir_diamond/${STEM}_${STEM_db}.daa -t ./ -k 1 --sensitive --evalue 1e-10
		$diamond_location view --daa $output_dir_diamond/${STEM}_${STEM_db}.daa -o $output_dir_diamond/${STEM}_${STEM_db}.txt -f tab
	done	
done	
