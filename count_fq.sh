#!/bin/bash

# Take input directory 
read -p "Enter input directory: " indir
touch $indir/count_fq_log.txt

for file in $indir/500*.fastq
do 
	STEM=$(basename "${file}" .fastq)
	echo ${STEM} >> $indir/count_fq_log.txt
 
	echo $(cat $file|wc -l)/4|bc >> $indir/count_fq_log.txt
done

