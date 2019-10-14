#!/bin/bash

# Trimmomatic
#trimmomatic_location=/home/xzyao/miniconda3/pkgs/trimmomatic-0.39-1/share/trimmomatic-0.39-1/trimmomatic.jar
## FastUniq 
#fastuniq_location=/home/xzyao/miniconda3/pkgs/fastuniq-1.1-h470a237_1/bin/fastuniq


###################################################################
#
# STEP 2: USE TRIMMOMATIC TO REMOVE LOW-QUALITY READS
# Take input from BMTagger (removal of the human DNA)
# Trimmomatic parameters followed this paper (Taft et al., 2018, mSphere), using the paired end mode 

#echo "NOW STARTING READ CLEANING WITH TRIMMOMATIC AT: "; date 

#module load java trimmomatic

#input_dir_trim=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step_1_BMTagger_output
#mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2_trim/ # only need to run once 
#output_dir_trim=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2_trim
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
#
#
#
####################################################################
##
## STEP 3: Remove duplicated reads
## For FastUniq options: https://wiki.gacrc.uga.edu/wiki/FastUniq
#
#echo "NOW STARTING REMOVING DUPLICATE READS AT: "; date 
#
#mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step3_fastuniq
output_dir_dup=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_trim_fastuniq_pear/step3_fastuniq/
#
#touch $output_dir_dup/fastuniq_input_list.txt
#fastuniq_input_list=$output_dir_dup/fastuniq_input_list.txt
#
#for file in $output_dir_trim/*R1_paired.fastq
#do 
#	# clear the content of the list file so that FastUniq takes only 2 files every time it runs
#	> $fastuniq_input_list
#
#	STEM=$(basename "${file}" 1_paired.fastq)
#
#	file1=$file
#	file2=$output_dir_trim/${STEM}2_paired.fastq
#
#	echo $file1 >> $fastuniq_input_list
#	echo $file2 >> $fastuniq_input_list
#
#	# Althoug FastUniq takes list as input !!!!DO NOT SUPPLY ALL FILES IN ONE LIST!!!!
#	# Because FastUniq can only write out 2 files for forward and reverse
#	# Run FastUniq
#	$fastuniq_location -i $fastuniq_input_list -t q -o $output_dir_dup/${STEM}1_dup.fastq -p $output_dir_dup/${STEM}2_dup.fastq
#done



###################################################################
#
# STEP 4: Merge paired-end reads with BBmerge
# Help and usage page: http://seqanswers.com/forums/showthread.php?t=58221 
# https://jgi.doe.gov/data-and-tools/bbtools/bb-tools-user-guide/bbmap-guide/

echo "NOW STARTING PAIRED-END MERGING WITH BBmerge AT: "; date

# load module to us bbmerge
module load java bbmap
# BBmerge location: /software/bbmap/37.68/static/bbmerge.sh

mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_trim_fastuniq_bbmerge/
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_trim_fastuniq_bbmerge/step4_bbmerge
output_dir_bbmerge=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_trim_fastuniq_bbmerge/step4_bbmerge

for file in $output_dir_dup/*1_dup.fastq
do
	STEM=$(basename "${file}" R1_dup.fastq)

	file1=$file
	file2=$output_dir_dup/${STEM}R2_dup.fastq

	# -h for help page
	bbmerge.sh in=$file1 in2=$file2 out=$output_dir_bbmerge/${STEM}_merged.fastq outu=$output_dir_bbmerge/${STEM}_R1_unmerged.fastq outu2=$output_dir_bbmerge/${STEM}_R2_unmerged.fastq ihist=$output_dir_bbmerge/${STEM}.hist minoverlap=10 adapter=/share/lemaylab-backedup/milklab/programs/trimmomatic_adapter_input.fa 
done
