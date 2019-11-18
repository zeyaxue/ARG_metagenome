#!/bin/bash 

####################################################################
#
# STEP 7. Count the MEGARes database alignment and normalize the count 
# table with MicrobeCensus generated genome equivalents per sample

run_dir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043

#echo "NOW MAKING COUNT TABLE AT: "; date
#
## set input and output file paths
#mkdir $run_dir/step7_norm_count_tab/
#mkdir $run_dir/step7_norm_count_tab/resistomeanalyzer_output
ra_outdir=$run_dir/step7_norm_count_tab/resistomeanalyzer_output
megares_outdir=$run_dir/step6_megares_bwa
#
## Make sure bash knows where to look for softwares
#ranalyzer=/share/lemaylab-backedup/milklab/programs/resistomeanalyzer/resistome
#megares_dir=/share/lemaylab-backedup/milklab/database/megares_v2
#
#
#for file in $megares_outdir/*_align.sam
#do
#	STEM=$(basename "$file" _align.sam)
#
#	# usage instructions: https://github.com/cdeanj/resistomeanalyzer
#	$ranalyzer \
#	-ref_fp $megares_dir/megares_modified_database_v2.00.fasta \
#	-sam_fp $file \
#	-annot_fp $megares_dir/megares_modified_annotations_v2.00.csv \
#	-gene_fp $ra_outdir/${STEM}_gene.tsv \
#	-group_fp $ra_outdir/${STEM}_group.tsv \
#	-class_fp $ra_outdir/${STEM}_class.tsv \
#	-mech_fp $ra_outdir/${STEM}_mechanism.tsv \
#	-t 80 #Threshold to determine gene significance
#done	
#



echo "NOW STARTING COUNT TABLE NORMALIZATION AT: "; date

norm=/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/make_RPKG_normtab.py

mc_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step5_MicrobeCensus
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step7_norm_count_tab/normalized_tab
norm_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step7_norm_count_tab/normalized_tab

# make sure python knows where to look for pkgs
export PATH="/home/xzyao/.local/bin:$PATH"

for file in $ra_outdir/*_gene.tsv
do
	STEM=$(basename "$file" _gene.tsv)

	python $norm \
	--mc $mc_outdir/${STEM}_allreads_mc.txt \
	--genelen /share/lemaylab-backedup/milklab/database/megares_v2/megares_modified_database_v2_GeneLen_org.tsv \
	--count $file \
	--out $norm_outdir/${STEM}_norm.csv \
	--mergein $file # This argument does not do anything here, but python2 requires *args to be not empty so I supply a dummy argument (if using python3, can omit this input)
done	


# use the python script again to merge tables
python $norm \
	--mergeout $norm_outdir/merge_norm_final.csv \
	--mergein $norm_outdir/*_norm.csv # 



