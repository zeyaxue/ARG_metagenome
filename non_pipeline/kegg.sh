#!/bin/bash 

## before start the script, start the conda env by 'conda activate metagenome_zx'

run_dir=/home/AMR_metagenome/processed_data/Novaseq_072rerun

# DIAMOND
diamond_location=/software/diamond-0.9.21/diamond
db=/database/kegg/genes/fasta/prokaryotes.pep.dmnd

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

for file in $output_dir_kegg/*.txt
do	
	STEM=$(basename "$file" .txt)

	if [ -f $output_dir_kegg/${STEM}_norm.csv ]
	then 
		echo "${STEM}_norm.csv exist"
	else	
		echo "counting sample ${STEM}"

		# organize the DIAMOND alignment file to count table 
		python /home/AMR_metagenome/scripts/kegg_db_analysis_counter.py --in $output_dir_kegg/${STEM}.txt --out $output_dir_kegg/${STEM}.csv

		# normalized count table
		python /home/AMR_metagenome/scripts/make_KEGG_normtab.py --mc $run_dir/step5_MicrobeCensus_merged/${STEM}_mc.txt --genelen /database/kegg/genes/fasta/prokaryotes.pep_gene_length_2cols.txt --count $output_dir_kegg/${STEM}.csv --out $output_dir_kegg/${STEM}_norm.csv --mergein $file # This argument does not do anything here, but python2 requires *args to be not empty so I supply a dummy argument (if using python3, can omit this input)

	fi
done	

# add corresponding KEGG ids to each gene



echo "KEGG alignment DONE AT: "; date