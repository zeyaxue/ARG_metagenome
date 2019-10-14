#!/bin/bash

# Take input directory 
read -p "Enter input directory: " indir
touch $indir/count_fq_log.txt
# Determine if input is fastq or gz
read -p "Enter fq if input is fastq. Enter gz if input is zipped fastq: " format


if [ "$format" = "fq" ]
then 
	for file in $indir/*.fastq
	do 
		STEM=$(basename "${file}" .fastq)
		echo ${STEM} >> $indir/count_fq_log.txt	
	 
		echo $(cat $file|wc -l)/4|bc >> $indir/count_fq_log.txt
	done
elif [ "$format" = "gz" ]
then
	for file in $indir/*.gz
	do 
		STEM=$(basename "${file}" .fastq.gz )
		echo ${STEM} >> $indir/count_fq_log.txt	
	 
		echo $(zcat $file|wc -l)/4| >> $indir/count_fq_log.txt
	done	
else 
	echo "Please input between fq and gz" 
fi

# organize file
cd $indir

# Make sampleID column
## I tried over several hours to wrangle the data in variables but that did not work
awk 'NR%2==1' count_fq_log.txt > col1.txt  # use $() to denote everthing between () are excutable commands
awk 'NR%2==1' col1.txt > col1a.txt  # because every sample name is listed twice 
$(echo sampleID > col1b.txt) # column header
$(sed 's/_S.*//' col1a.txt >> col1b.txt) # need the . period symbol for wildcard to work


# Make read column
awk 'NR%2==0' count_fq_log.txt > col2.txt
$(echo lib_size > col2a.txt)
$(awk 'NR%2==1' col2.txt >> col2a.txt)

$(paste col1b.txt col2a.txt -d "\t" > lib_size.txt)
rm col*
