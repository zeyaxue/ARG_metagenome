#!/bin/bash

#SBATCH --mail-user=zhxue@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=trim_Fastuniq_merge
#SBATCH --cpus-per-task 7

#       3. Trimmomatic
trimmomatic_location=/home/xzyao/miniconda3/pkgs/trimmomatic-0.39-1/bin

###################################################################
#
# STEP 2: USE TRIMMOMATIC TO REMOVE LOW-QUALITY READS
# Take input from BMTagger (removal of the human DNA)
# Trimmomatic parameters followed this paper (Taft et al., 2018, mSphere), using the paired end mode 

echo "NOW STARTING READ CLEANING WITH TRIMMOMATIC AT: "; date 

module load java trimmomatic

input_dir=/share/lemaylab-backedup/Zeya/proceesed_data/test_no_humuan_dataset
#mkdir /share/lemaylab-backedup/Zeya/proceesed_data/step2_trim/
output_dir=/share/lemaylab-backedup/Zeya/proceesed_data/step2_trim/

for file in $input_dir/*R1_nohuman_1000* 
do
	STEM=$(basename "${file}" 1_nohuman_1000reads.fastq)

	file1=$file
	file2=${STEM}2_nohuman_1000reads.fastq
	echo $file2

	java -jar $trimmomatic_location PE $file1 $file2 ${STEM}_R1_1000reads_paired.fastq ${STEM}_R1_1000reads_unpaired.fastq.gz ${STEM}_R2_1000reads_paired.fastq ${STEM}_R2_1000reads_unpaired.fastq.gz -phred33 SLIDINGWINDOW:4:15 MINLEN:99
done
