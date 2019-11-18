#!/bin/bash

# usage: source count_fq.sh gz/fq indir outfile    

touch $2/count_fq_log.txt

# get the 


if [ "$1" = "fq" ]
then 
	for file in $2/*.fastq
	do 
		STEM=$(basename "$file" .fastq)
		echo ${STEM} >> $2/count_fq_log.txt	
	 
		echo $(cat $file|wc -l)/4|bc >> $2/count_fq_log.txt
	done
elif [ "$1" = "gz" ]
then
	for file in $2/*.fastq.gz
	do 
		STEM=$(basename "$file" .fastq.gz )
		echo ${STEM} >> $2/count_fq_log.txt	
	 
		echo $(zcat $file|wc -l)/4| >> $2/count_fq_log.txt
	done	
else 
	echo "Please input between fq and gz" 
fi

# organize file
cd $2

# Make sampleID column
## I tried over several hours to wrangle the data in variables but that did not work
awk 'NR%2==1' count_fq_log.txt > col1a.txt  # use $() to denote everthing between () are excutable commands
$(echo sampleID > col1b.txt) # column header
$(sed 's/_.*//' col1a.txt >> col1b.txt) # need the . period symbol for wildcard to work

# Make read column
$(echo lib_size > col2.txt)
awk 'NR%2==0' count_fq_log.txt >> col2.txt

# Combine 2 columns to final stats file
$(paste col1b.txt col2.txt -d "\t" > $3)

