#!/bin/bash

#SBATCH --mail-user=zhxue@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=trim_Fastuniq_merge
#SBATCH --cpus-per-task 7

# Trimmomatic
trimmomatic_location=/home/xzyao/miniconda3/pkgs/trimmomatic-0.39-1/share/trimmomatic-0.39-1/trimmomatic.jar
# FastUniq 
fastuniq_location=/home/xzyao/miniconda3/pkgs/fastuniq-1.1-h470a237_1/bin/fastuniq

###################################################################
#
# STEP 2: USE TRIMMOMATIC TO REMOVE LOW-QUALITY READS
# Take input from BMTagger (removal of the human DNA)
# Trimmomatic parameters followed this paper (Taft et al., 2018, mSphere), using the paired end mode 

echo "NOW STARTING READ CLEANING WITH TRIMMOMATIC AT: "; date 

module load java trimmomatic

input_dir_trim=/share/lemaylab-backedup/Zeya/proceesed_data/test_no_humuan_dataset
#mkdir /share/lemaylab-backedup/Zeya/proceesed_data/step2_trim/ # only need to run once 
output_dir_trim=/share/lemaylab-backedup/Zeya/proceesed_data/test_no_humuan_dataset/step2_trim

for file in $input_dir_trim/*R1_nohuman_1000* 
do
	STEM=$(basename "${file}" 1_nohuman_1000reads.fastq)

	file1=$file
	file2=$input_dir_trim/${STEM}2_nohuman_1000reads.fastq

	java -jar $trimmomatic_location PE $file1 $file2 $output_dir_trim/${STEM}1_1000reads_paired.fastq $output_dir_trim/${STEM}1_1000reads_unpaired.fastq.gz $output_dir_trim/${STEM}2_1000reads_paired.fastq $output_dir_trim/${STEM}2_1000reads_unpaired.fastq.gz -phred33 SLIDINGWINDOW:4:15 MINLEN:99
done



###################################################################
#
# STEP 3: Remove duplicated reads
# For FastUniq options: https://wiki.gacrc.uga.edu/wiki/FastUniq

echo "NOW STARTING REMOVING DUPLICATE READS AT: "; date 

#mkdir /share/lemaylab-backedup/Zeya/proceesed_data/test_no_humuan_dataset/step3_fastuniq
output_dir_dup=/share/lemaylab-backedup/Zeya/proceesed_data/test_no_humuan_dataset/step3_fastuniq

touch $output_dir_dup/fastuniq_input_list.txt
fastuniq_input_list=$output_dir_dup/fastuniq_input_list.txt

for file in $output_dir_trim/*R1_1000reads_paired.fastq
do 
	STEM=$(basename "${file}" 1_1000reads_paired.fastq)

	file1=$file
	file2=$output_dir_trim/${STEM}2_1000reads_paired.fastq

	echo $file1 >> $fastuniq_input_list
	echo $file2 >> $fastuniq_input_list
done

# Run FastUniq
$fastuniq_location -i $fastuniq_input_list -t q -o $output_dir_dup/1.fastq -p $output_dir_dup/2.fastq
