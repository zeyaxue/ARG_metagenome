#!/bin/bash

flash_dir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_trim_fastuniq_flash/step4_flash
bbmerge_dir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_trim_fastuniq_bbmerge/step4_bbmerge
outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/merged_fq_header_comp

# Use filterbyname.sh within BBmap module to get the the unique fastq sequences 
## (shared fastq headers between bbmerge and flash will be filtered)
# bbmap module location: /software/bbmap/37.68/static/bbmap.sh
# I included a local copy of this program: /share/lemaylab-backedup/milklab/programs/filterbyname_v37.68.sh

module load java bbmap

# sequence only foud in flash but not bbmerge
for file in $flash_dir/*..extendedFrags.fastq
do 	
	STEM=$(basename "$file" ..extendedFrags.fastq)
	
	filterbyname.sh in=$file out=$outdir/${STEM}_flash_bb_uniq.fastq names=$bbmerge_dir/${STEM}._merged.fastq
done	


# sequences only found in bbmerge but not flash
for file in $bbmerge_dir/*._merged.fastq
do 	
	STEM=$(basename "$file" ._merged.fastq)
	
	filterbyname.sh in=$file out=$outdir/${STEM}_bb_flash_uniq.fastq names=$flash_dir/${STEM}..extendedFrags.fastq 
done


# You can usd the output $outdir/${STEM}_flash_bb_uniq.fastq and outdir/${STEM}_bb_flash_uniq.fastq to acquire 
# the names of the unique headers, if needed. 

# count the library size (read number) of the uniqe fastq file 
/share/lemaylab-backedup/Zeya/scripts/gitSRC/ARG_metagenome/count_fq.sh $outdir $outdir/unique_read_count.txt fq



# after getting the file containing number of unique fastq sequences/header, compare with both flash and bbmerge generated 
# files to see the % of unique reads 