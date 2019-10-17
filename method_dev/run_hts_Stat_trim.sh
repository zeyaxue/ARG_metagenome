#!/bin/bash

# hts_Stats
htsStat_location=/share/lemaylab-backedup/milklab/programs/HTStream_1.0.0/hts_Stats

# Take input directory 
read -p "Enter input directory: " indir

# For help and hts_Stat options
# /share/lemaylab-backedup/milklab/programs/HTStream_1.0.0/hts_Stats -h 
for file in $indir/*R1_paired.fastq
do 
	STEM=$(basename "${file}" .R1_paired.fastq)
	file1=$file
	file2=$indir/$(basename $file1 | sed 's/R1/R2/')

	$htsStat_location -1 $file1 -2 $file2 -g -p $indir/${STEM} -L $indir/${STEM}stats.log 

done
