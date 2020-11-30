#!/bin/bash


########################################################################################################################
#
# STEP 9. ALIGN SHORT READS CONTAINING ARG TO CONTIGS

echo "NOW STARTING SHORT READ AND CONTIG ALIGNMENT AT: "; date

run_dir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq112

# Set input and output file paths
megares_outdir=$run_dir/step6_megares_bwa
megahit_outdir=$run_dir/step8_megahit_in_trimmomatic
mkdir $run_dir/step9_contig_bwa_nomerg
aln_outdir=$run_dir/step9_contig_bwa_nomerg
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
		echo "Processing sample ${STEM} now......"	
	
		# convert sam file to fastq and keep only reads that are mapped
		# usage: https://jgi.doe.gov/data-and-tools/bbtools/bb-tools-user-guide/reformat-guide/
		# https://github.com/BioInfoTools/BBMap/blob/master/sh/reformat.sh
		#$bbmap/reformat.sh in=$file out=$aln_outdir/mapped_fastq/${STEM}_megares_map.fastq mappedonly
			
		# use bwa to index and align contigs with short reads containing ARGs
		#$bwa index $megahit_outdir/${STEM}_assembled/final.contigs.fa
		#$bwa mem -t 15 $megahit_outdir/${STEM}_assembled/final.contigs.fa $aln_outdir/mapped_fastq/${STEM}_megares_map.fastq > $aln_outdir/${STEM}_contig_ARGread_aln.sam

		# get the contigs header containing ARG 
		#$bbmap/reformat.sh in=$aln_outdir/${STEM}_contig_ARGread_aln.sam out=$aln_outdir/${STEM}_contig_ARGread_aln_mappedonly.sam mappedonly 
		
		# gather A0-based run header from the sam file & add a space after each line for the 1st field of the actual contig header (annoying reformating due to spaces in the contig header, e.g: ">k141_49608 flag=0 multi=1.0000 len=233")
		grep 'A0' $aln_outdir/${STEM}_contig_ARGread_aln_mappedonly.sam | cut -f 3 > $aln_outdir/${STEM}_header.txt
		python $pyhd --i $aln_outdir/${STEM}_header.txt --f $megahit_outdir/${STEM}_assembled/final.contigs.fa --o $aln_outdir/${STEM}_header.txt

		# filter use the above list to retain ARG read aligned contigs
		# http://seqanswers.com/forums/archive/index.php/t-75650.html
		$bbmap/filterbyname.sh in=$megahit_outdir/${STEM}_assembled/final.contigs.fa out=$aln_outdir/${STEM}_contig_ARGread_aln_mappedonly.fa names=$aln_outdir/${STEM}_header.txt include=t 
	fi	
done	

echo "STEP 9 DONE AT: "; date