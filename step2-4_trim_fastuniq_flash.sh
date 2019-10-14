#!/bin/bash

#SBATCH --mail-user=zhxue@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=trim_Fastuniq_merge
#SBATCH --cpus-per-task 7

# Trimmomatic
#trimmomatic_location=/home/xzyao/miniconda3/pkgs/trimmomatic-0.39-1/share/trimmomatic-0.39-1/trimmomatic.jar
## FastUniq 
#fastuniq_location=/home/xzyao/miniconda3/pkgs/fastuniq-1.1-h470a237_1/bin/fastuniq
# FLASH
flash_location=/share/lemaylab-backedup/milklab/programs/FLASH-1.2.11_2019/FLASH-1.2.11-Linux-x86_64/flash

###################################################################
#
# STEP 2: USE TRIMMOMATIC TO REMOVE LOW-QUALITY READS
# Take input from BMTagger (removal of the human DNA)
# Trimmomatic parameters followed this paper (Taft et al., 2018, mSphere) and using the paired end mode 
# from link: http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/TrimmomaticManual_V0.32.pdf

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
#	# remove adapter and trimming at the same time (TrueSeq3-PE-2.fa, PE1_rc and PE2_rc)
#	java -jar $trimmomatic_location PE -threads 5 -trimlog $output_dir_trim/trimmomatic_log.txt $file1 $file2 $output_dir_trim/${STEM}1_paired.fastq $output_dir_trim/${STEM}1_unpaired.fastq.gz $output_dir_trim/${STEM}2_paired.fastq $output_dir_trim/${STEM}2_unpaired.fastq.gz -phred33 /share/lemaylab-backedup/milklab/programs/trimmomatic_adapter_input.fa:2:30:10 SLIDINGWINDOW:4:15 MINLEN:99
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
output_dir_dup=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step3_fastuniq
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
# STEP 4: Merge paired-end reads with FLASH
# The FLASH manual link: http://ccb.jhu.edu/software/FLASH/MANUAL

echo "NOW STARTING PAIRED-END MERGING WITH FLASH AT: "; date

#mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step4_flash
output_dir_flash=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step4_flash

for file in $output_dir_dup/*1_dup.fastq
do
	STEM=$(basename "${file}" R1_dup.fastq)

	file1=$file
	file2=$output_dir_dup/${STEM}R2_dup.fastq

	# -m: minium overlap length 10bp to be similar to pear 
	# -M: max overlap length 
	# -x: mismatch ratio, default is 0.25, which is quite high (e.g: 50bp overlap --> 12.5 mismatch by default)
	$flash_location $file1 $file2 -m 10 -M 100 -x 0.1 -o ${STEM} -d $output_dir_flash
done
