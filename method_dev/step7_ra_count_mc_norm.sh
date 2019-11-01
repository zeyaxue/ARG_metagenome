#!/bin/bash 

####################################################################
#
# STEP 7. Count the MEGARes database alignment and normalize the count 
# table with MicrobeCensus generated genome equivalents per sample

echo "NOW MAKING COUNT TABLE AT: "; date

ranalyzer=/share/lemaylab-backedup/milklab/programs/resistomeanalyzer/resistome
output_dir_megares=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step6_megares_bwa
megares_dir=/share/lemaylab-backedup/milklab/database/megares_v2

mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step7_norm_count_tab/
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step7_norm_count_tab/resistomeanalyzer_output
output_dir_ra=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step7_norm_count_tab/resistomeanalyzer_output

#for file in $output_dir_megares/*_align.sam
#do
#	STEM=$(basename "$file" _align.sam)
#
#	# usage instructions: https://github.com/cdeanj/resistomeanalyzer
#	$ranalyzer \
#	-ref_fp $megares_dir/megares_modified_database_v2.00.fasta \
#	-sam_fp $file \
#	-annot_fp $megares_dir/megares_modified_annotations_v2.00.csv \
#	-gene_fp $output_dir_ra/${STEM}_gene.tsv \
#	-group_fp $output_dir_ra/${STEM}_group.tsv \
#	-class_fp $output_dir_ra/${STEM}_class.tsv \
#	-mech_fp $output_dir_ra/${STEM}_mechanism.tsv \
#	-t 80 #Threshold to determine gene significance
#done	




echo "NOW STARTING COUNT TABLE NORMALIZATION AT: "; date

norm=/share/lemaylab-backedup/Zeya/scripts/gitSRC/ARG_metagenome/make_RPKG_normtab.py

output_dir_mc=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step5_MC_test
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step7_norm_count_tab/normalized_tab
output_dir_norm=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step7_norm_count_tab/normalized_tab

# make sure python knows where to look for pkgs
export PATH="/home/xzyao/.local/bin:$PATH"

for file in $output_dir_ra/*_gene.tsv
do
	STEM=$(basename "$file" _gene.tsv)

	python $norm \
	--mc $output_dir_mc/${STEM}_mc.txt \
	--genelen /share/lemaylab-backedup/milklab/database/megares_v2/megares_modified_database_v2_GeneLen_org.tsv \
	--count $file \
	--out $output_dir_norm/${STEM}_norm.tsv \
	--mergein $file # This argument does not do anything here, but python2 requires *args to be not empty so I supply a dummy argument (if using python3, can omit this input)
done	


# use the python script again to merge tables
python $norm \
	--mergeout $output_dir_norm/merge_norm_final.tsv \
	--mergein $output_dir_norm/*_norm.tsv # 



