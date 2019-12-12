#!/bin/bash


########################################################################################################################
#
# STEP 9. ALIGN SHORT READS CONTAINING ARG TO CONTIGS

echo "NOW STARTING SHORT READ AND CONTIG ALIGNMENT AT: "; date

# Set input and output file paths
megares_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step6_megares_bwa
megahit_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step8_megahit
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step9_contig_bwa
aln_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step9_contig_bwa
mkdir $aln_outdir/mapped_fastq

# Make sure bash knows where to look for softwares 
bbmap=/software/bbmap/37.68/static/
bwa=/software/bwa/0.7.16a/lssc0-linux/bwa
pyhd=/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/prefix_to_compline.py

for file in $megares_outdir/*_align.sam
do
	STEM=$(basename "$file" _align.sam)
	
	if [ -f $aln_outdir/${STEM}_contig_aln.fasta ]
	then 	
		echo "$aln_outdir/${STEM}_contig_aln.fasta exist"
	else
		echo "Processing sample $STEM now......"	
	
		# convert sam file to fastq and keep only reads that are mapped
		# usage: https://jgi.doe.gov/data-and-tools/bbtools/bb-tools-user-guide/reformat-guide/
		#$bbmap/reformat.sh in=$file out=$aln_outdir/mapped_fastq/${STEM}_megares_map.fastq mappedonly
	
		# use bwa to index and align contigs with short reads containing ARGs
		#$bwa index $megahit_outdir/${STEM}_assembled/final.contigs.fa
		#$bwa mem -t 15 $megahit_outdir/${STEM}_assembled/final.contigs.fa $aln_outdir/mapped_fastq/${STEM}_megares_map.fastq > $aln_outdir/${STEM}_contig_aln.sam
	
		# get the contigs header containing ARG 
		#$bbmap/reformat.sh in=$aln_outdir/${STEM}_contig_aln.sam out=$aln_outdir/${STEM}_contig_aln_maponly.sam mappedonly 
		# change A0 based on run header & # add a space after each line for the 1st filed of the actual contig header
		#grep 'A0' $aln_outdir/${STEM}_contig_aln_maponly.sam | cut -f 3 > ${STEM}_header.txt
		python $pyhd --i ${STEM}_header.txt --f $megahit_outdir/${STEM}_assembled/final.contigs.fa --o $aln_outdir/${STEM}_header.txt
	
		$bbmap/filterbyname.sh in=$megahit_outdir/${STEM}_assembled/final.contigs.fa \
		out=$aln_outdir/${STEM}_contig_aln.fasta \
		names=$aln_outdir/${STEM}_header.txt \
		include=t
	fi	
done	

echo "STEP 9 DONE AT: "; date