#!/bin/bash

###################################################################
#
# STEP 7.2 Count the MEGARes database alignment and subsettting sequence reads to 
# make rarefaction analysis

echo "NOW STARTING RAREFACTION ANALYSIS AT: "; date

rare=/share/lemaylab-backedup/milklab/programs/RarefactionAnalyzer/rarefaction
output_dir_megares=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step6_megares_bwa
megares_dir=/share/lemaylab-backedup/milklab/database/megares_v2


mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step7.2_rare
output_dir_rare=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step7.2_rare


for file in $output_dir_megares/*_align.sam
do
	STEM=$(basename "$file" _align.sam)

	# usage instructions: https://github.com/cdeanj/rarefactionanalyzer
	$rare \
	-ref_fp $megares_dir/megares_modified_database_v2.00.fasta \
	-annot_fp $megares_dir/megares_modified_annotations_v2.00.csv \
	-sam_fp $file \
	-gene_fp $output_dir_rare/${STEM}_gene.tsv \
	-group_fp $output_dir_rare/${STEM}_group.tsv \
	-mech_fp $output_dir_rare/${STEM}_mechanism.tsv \
	-class_fp $output_dir_rare/${STEM}_class.tsv \
	-min 5 \
	-max 100 \
	-skip 0 \
	-samples 1 \
	-t 80 #Threshold to determine gene significance
	# min: Starting sample level, proportions of samples 
done	