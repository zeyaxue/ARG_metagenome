#!/bin/bash 

run_dir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043

# DIAMOND
diamond_location=/share/lemaylab-backedup/milklab/programs/diamond
db=/share/lemaylab-backedup/databases/kegg/genes/fasta/prokaryotes.pep.dmnd

####################################################################
#
# Align to KEGG database with diamond
# for diamond usage, read manual: https://github.com/bbuchfink/diamond

# workflow example: https://github.com/LangilleLab/microbiome_helper/wiki/CBW-2016-Metagenomics-Functional-Tutorial

output_dir_flash=$run_dir/step4_flash
mkdir $run_dir/kegg_prokaryotes_pep
output_dir_kegg=$run_dir/kegg_prokaryotes_pep

for file in $output_dir_flash/*.extendedFrags.fastq
do
	STEM=$(basename "$file" .extendedFrags.fastq)

	if [ -f $output_dir_kegg/${STEM}.txt ]
	then 
		echo "${STEM}.txt exist"
	else 
		echo "Processing sample ${STEM} now"	

		# eval chosen based on recommendations for 200-250bp reads
		$diamond_location blastx --db $db -q $file -a $output_dir_kegg/${STEM}.daa \
		-t ./ -k 1 --sensitive --evalue 1e-25
		$diamond_location view --daa $output_dir_kegg/${STEM}.daa -o $output_dir_kegg/${STEM}.txt -f tab	
	fi
done


# Count/organize the DIAMOND output file

echo "KEGG alignment DONE AT: "; date