#!/bin/bash

#SBATCH --mail-user=zhxue@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=trim_Fastuniq_merge
#SBATCH --cpus-per-task 7

# Trimmomatic
trimmomatic_location=/home/xzyao/miniconda3/pkgs/trimmomatic-0.39-1/share/trimmomatic-0.39-1/trimmomatic.jar
# Pardre
pardre_location=/share/lemaylab-backedup/milklab/programs/ParDRe-rel2.2.5/ParDRe 
#PEAR
pear_location=/share/lemaylab-backedup/milklab/programs/pear-0.9.6/pear-0.9.6


###################################################################
#
# STEP 2: USE TRIMMOMATIC TO REMOVE LOW-QUALITY READS
# Take input from BMTagger (removal of the human DNA)
# Trimmomatic parameters followed this paper (Taft et al., 2018, mSphere), using the paired end mode 

#echo "NOW STARTING READ CLEANING WITH TRIMMOMATIC AT: "; date 
#
#module load java trimmomatic
#
#input_dir_trim=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step_1_BMTagger_output
#mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_trim_fastuniq_pear/step2_trim/ # only need to run once 
output_dir_trim=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_trim_fastuniq_pear/step2_trim
#
#for file in $input_dir_trim/500*R1_nohuman.fastq # test with 4 files first (5002, 5005, 5006, 5007)
#do
#	STEM=$(basename "${file}" 1_nohuman.fastq)
#
#	file1=$file
#	file2=$input_dir_trim/${STEM}2_nohuman.fastq
#
#	java -jar $trimmomatic_location PE -threads 5 -trimlog $output_dir_trim/trimmomatic_log.txt $file1 $file2 $output_dir_trim/${STEM}1_paired.fastq $output_dir_trim/${STEM}1_unpaired.fastq.gz $output_dir_trim/${STEM}2_paired.fastq $output_dir_trim/${STEM}2_unpaired.fastq.gz -phred33 SLIDINGWINDOW:4:15 MINLEN:99
#done



###################################################################
#
# STEP 3: Remove duplicated reads with Pardre
# For Pardre options, see the manual included in the software download
# link: https://sourceforge.net/projects/pardre/ 

echo "NOW STARTING REMOVING DUPLICATE READS AT: "; date 

mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_trim_pardre_pear
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_trim_pardre_pear/step3_pardre
output_dir_dup=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_trim_pardre_pear/step3_pardre


for file in $output_dir_trim/*R1_paired.fastq
do 
	STEM=$(basename "${file}" 1_paired.fastq)

	file1=$file
	file2=$output_dir_trim/${STEM}2_paired.fastq

	# -m mismatch number
	# -l prefix length used to cluster reads (can be thought of as the starting base to compare)
	# -c length of sequence to compare, default: entire length, starting from the first base
	$pardre_location -i $file1 -p $file2 -o $output_dir_dup/${STEM}1_dup.fastq -r $output_dir_dup/${STEM}2_dup.fastq -l 5  
done



###################################################################
#
# STEP 4: Merge paired-end reads
# Link to PEAR website: https://cme.h-its.org/exelixis/web/software/pear/
# https://www.h-its.org/research/cme/software/#NextGenerationSequencingSequenceAnalysis

echo "NOW STARTING PAIRED-END MERGING WITH PEAR AT: "; date

mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_trim_pardre_pear/step4_pear
output_dir_pear=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_trim_pardre_pear/step4_pear

for file in $output_dir_dup/*1_dup.fastq
do
	STEM=$(basename "${file}" R1_dup.fastq)

	file1=$file
	file2=$output_dir_dup/${STEM}R2_dup.fastq

	$pear_location -f $file1 -r $file2 -o $output_dir_pear/${STEM} -j 5 # run on 5 threads
done
