#!/bin/bash

# hts_Stats
htsStat_location=/share/lemaylab-backedup/milklab/programs/HTStream_1.0.0/hts_Stats

# Take input directory 
read -p "Enter input directory: " indir

# For help and hts_Stat options
# /share/lemaylab-backedup/milklab/programs/HTStream_1.0.0/hts_Stats -h 
for file in $indir/*.assembled.fastq
do 
	STEM=$(basename "${file}" .assembled.fastq)
	file1=$file

	$htsStat_location -U $file1 -p $indir/${STEM} -g =L $indir/${STEM}stats.log

done
