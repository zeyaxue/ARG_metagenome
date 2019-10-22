#!/bin/bash

# usage: source count_fq.sh indir outfile gz/fq

touch $1/count_fq_log.txt

if [ "$3" = "fq" ]
then 
	for file in $1/*.fastq
	do 
		STEM=$(basename "${file}" .fastq)
		echo ${STEM} >> $1/count_fq_log.txt	
	 
		echo $(cat $file|wc -l)/4|bc >> $1/count_fq_log.txt
	done
elif [ "$3" = "gz" ]
then
	for file in $1/*.gz
	do 
		STEM=$(basename "${file}" .fastq.gz )
		echo ${STEM} >> $1/count_fq_log.txt	
	 
		echo $(zcat $file|wc -l)/4| >> $1/count_fq_log.txt
	done	
else 
	echo "Please input between fq and gz" 
fi

# organize file
cd $1

# Make sampleID column
## I tried over several hours to wrangle the data in variables but that did not work
awk 'NR%2==1' count_fq_log.txt > col1a.txt  # use $() to denote everthing between () are excutable commands
#awk 'NR%2==1' col1.txt > col1a.txt  # because every sample name is listed twice 
$(echo sampleID > col1b.txt) # column header
$(sed 's/_S.*//' col1a.txt >> col1b.txt) # need the . period symbol for wildcard to work


# Make read column
$(echo lib_size > col2a.txt)
awk 'NR%2==0' count_fq_log.txt >> col2a.txt
#$(awk 'NR%2==1' col2.txt >> col2a.txt)# because every sample name is listed twice 

$(paste col1b.txt col2a.txt -d "\t" > $2)
rm col*
