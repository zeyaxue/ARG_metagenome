#!/bin/bash



# Trimmomatic
trimmomatic_location=/home/xzyao/miniconda3/pkgs/trimmomatic-0.39-1/share/trimmomatic-0.39-1/trimmomatic.jar
# SuperDeduper
SupDup_location=/share/lemaylab-backedup/milklab/programs/HTStream_1.0.0/hts_SuperDeduper
# PEAR
pear_location=/share/lemaylab-backedup/milklab/programs/pear-0.9.6/pear-0.9.6


###################################################################
#
# STEP 2: Remove duplicated reads 
# For SuperDeduper tutorial: https://ucdavis-bioinformatics-training.github.io/2018-June-RNA-Seq-Workshop/tuesday/preproc.html
# for its options
# hts_SuperDeduper --help
#
#echo "NOW STARTING REMOVING DUPLICATE READS AT: "; date 
#
#input_dir_dup=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step_1_BMTagger_output
#mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_superdedup_trim_pear
#mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_superdedup_trim_pear/step2_superdup
#output_dir_dup=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_superdedup_trim_pear/step2_superdup


#for file in $input_dir_dup/500*.R1_nohuman.fastq # test with 4 files first (5002, 5005, 5006, 5007)
#do 
#	STEM=$(basename "${file}" 1_nohuman.fastq)
#
#	file1=$file
#	file2=$input_dir_dup/${STEM}2_nohuman.fastq
#
#	# -s starting bases 
#	# -l lentgh of unique ID/reads, i chose 140 for almost full length
#	$SupDup_location -1 $file1 -2 $file2 -p $output_dir_dup/${STEM} -f -s 5 -l 140
#done
#

###################################################################
#
# STEP 3: USE TRIMMOMATIC TO REMOVE LOW-QUALITY READS
# Take input from BMTagger (removal of the human DNA)
# Trimmomatic parameters followed this paper (Taft et al., 2018, mSphere), using the paired end mode 

#echo "NOW STARTING READ CLEANING WITH TRIMMOMATIC AT: "; date 

#module load java trimmomatic

#mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_superdedup_trim_pear/step3_trim/ # only need to run once 
output_dir_trim=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_superdedup_trim_pear/step3_trim

#for file in $output_dir_dup/*R1.fastq
#do
#	STEM=$(basename "${file}" R_R1.fastq)
#
#	file1=$file
#	file2=$output_dir_dup/${STEM}R_R2.fastq
#
#	java -jar $trimmomatic_location PE -threads 5 -trimlog $output_dir_trim/trimmomatic_log.txt $file1 $file2 $output_dir_trim/${STEM}.R1_paired.fastq $output_dir_trim/${STEM}.R1_unpaired.fastq.gz $output_dir_trim/${STEM}.R2_paired.fastq $output_dir_trim/${STEM}.R2_unpaired.fastq.gz -phred33 SLIDINGWINDOW:4:15 MINLEN:99
#done



###################################################################
#
# STEP 4: Merge paired-end reads
# Link to PEAR website: https://cme.h-its.org/exelixis/web/software/pear/
# https://www.h-its.org/research/cme/software/#NextGenerationSequencingSequenceAnalysis

echo "NOW STARTING PAIRED-END MERGING WITH PEAR AT: "; date

mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_superdedup_trim_pear/step4_pear
output_dir_pear=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_superdedup_trim_pear/step4_pear
echo $output_dir_trim

for file in $output_dir_trim/*R1_paired.fastq
do
	STEM=$(basename "${file}" R1_paired.fastq)

	file1=$file
	file2=$output_dir_trim/${STEM}R2_paired.fastq

	$pear_location -f $file1 -r $file2 -o $output_dir_pear/${STEM} -j 5 # run on 5 threads
done
