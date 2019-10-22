#!/bin/bash

flash_dir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_trim_fastuniq_flash/step4_flash
bbmerge_dir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_trim_fastuniq_bbmerge/step4_bbmerge

out_tab=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/merged_fq_header_comp/flash_bbmerge_N_bases.txt

# count the number of N base in a file 
# https://www.biostars.org/p/78043/
# count flash method
for file in $flash_dir/*..extendedFrags.fastq
do 	
	STEM=$(basename "$file" ..extendedFrags.fastq)
	echo ${STEM} >> colf.txt
	# count the number of lines (i.e. N count)
	awk 'NR%4==2' $file | grep -o [N] | wc -l >> colf.txt

done	

awk 'NR%2==1' colf.txt > col1f.txt # sampleID column 
awk 'NR%2==0' colf.txt > col2f.txt # Number of N column
$(paste col1f.txt col2f.txt -d "\t" > colf.txt)
sed -e 's/$/\t flash/' -i colf.txt # add method name to the end of the string at each line



# count bbmerge method 
for file in $bbmerge_dir/*._merged.fastq
do 	
	STEM=$(basename "$file" ._merged.fastq)
	echo ${STEM} >> colb.txt
	awk 'NR%4==2' $file | grep -o [N] | wc -l >> colb.txt

done

awk 'NR%2==1' colb.txt > col1b.txt # sampleID column 
awk 'NR%2==0' colb.txt > col2b.txt # Number of N column
$(paste col1b.txt col2b.txt -d "\t" > colb.txt)
sed -e 's/$/\t bbmerge/' -i colb.txt 

# combine flash and bbmerge table to one
cat colf.txt colb.txt > $out_tab
rm col*