#!/bin/bash

run_dir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq112

# DIAMOND
diamond_location=/share/lemaylab-backedup/milklab/programs/diamond
db=/share/lemaylab-backedup/databases/CAZy/CAZyDB.07312019.uniq.dmnd

####################################################################
#
# Align to CAZy database with diamond
# for diamond usage, read manual: https://github.com/bbuchfink/diamond

output_dir_flash=$run_dir/step4_flash
mkdir $run_dir/CAZy_diamond
output_dir_diamond=$run_dir/CAZy_diamond

# align to CAZy database with DIAMOND
for file in $output_dir_flash/*.extendedFrags.fastq
do
	STEM=$(basename "$file" .extendedFrags.fastq)

	# eval chosen based on recommendations for 200-250bp reads
	$diamond_location blastx --db $db -q $file -a $output_dir_diamond/${STEM}.daa -t ./ -k 1 --sensitive --evalue 1e-25
	$diamond_location view --daa $output_dir_diamond/${STEM}.daa -o $output_dir_diamond/${STEM}.txt -f tab	
done


for file in $output_dir_diamond/*.daa
do	
	STEM=$(basename "$file" .daa)

	echo "counting sample ${STEM}"

	# organize the DIAMOND alignment file to count table 
	python /share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/CAZy_db_analysis_counter.py --in $output_dir_diamond/${STEM}.txt --out $output_dir_diamond/${STEM}_org_by_gene.csv

	## organize and merge raw count table
	#python /share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/merge_organized_diamond_tab.py \
	#--in $output_dir_diamond/${STEM}_id_org.txt \
	#--out $output_dir_diamond/${STEM}_id_org_samid.txt \
	#--mergein $file # This argument does not do anything here, but python2 requires *args to be not empty so I supply a dummy argument 
	## organize and merge raw count table
	#python /share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/merge_organized_diamond_tab.py \
	#--mergeout $output_dir_diamond/merged_id_diamond_tab.csv \
	#--mergein $output_dir_diamond/*_id_org_samid.txt

	# Normalize count table with MicrobeCensus
	python /share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/make_CAZy_normtab.py --mc $run_dir/step5_MicrobeCensus_merged/${STEM}_mc.txt --genelen /share/lemaylab-backedup/databases/CAZy/CAZyDB.07312019.uniq.len.txt --count $output_dir_diamond/${STEM}_org_by_gene.csv --out $output_dir_diamond/${STEM}_org_by_gene_norm.csv --mergein $file # This argument does not do anything here, but python2 requires *args to be not empty so I supply a dummy argument (if using python3, can omit this input)
done

# Merge the count table from each sample to one file per run
python /share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/make_CAZy_normtab.py --mergeout $output_dir_diamond/merged_gene_norm_tab.csv --mergein $output_dir_diamond/*_org_by_gene_norm.csv 


echo "CAZy alignment DONE AT: "; date