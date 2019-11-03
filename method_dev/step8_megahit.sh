#!/bin/bash

####################################################################
#
# STEP 8. Assemble reads into contigs with megaHIT

echo "NOW STARTING ASEEMBLY WITH MEGAHIT AT: "; date

output_dir_flash=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_trim_fastuniq_flash/step4_flash
output_dir_dup=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_trim_fastuniq_pear/step3_fastuniq/
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step8_megahit
megahit_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step8_megahit

megahit=/share/lemaylab-backedup/milklab/programs/MEGAHIT-1.2.9-Linux-x86_64-static/bin/megahit


# assemble with both single (flash assembled) and paired end reads input (after fastuniq deduplicate)


# Take output from step4 flash of the step2-4_trim_fastuniq_flash workflow
for file in $output_dir_flash/*..extendedFrags.fastq
do
	STEM=$(basename "$file" ..extendedFrags.fastq)

	# usage instruction at https://github.com/voutcn/megahit & http://www.metagenomics.wiki/tools/assembly/megahit
	# use 50% memory and 12 threads
	$megahit -1 $output_dir_dup/${STEM}.R1_dup.fastq  -2 $output_dir_dup/${STEM}.R2_dup.fastq \
	-r $file \
	-m 0.5  -t 12 \
	-o $megahit_outdir/${STEM}_assembled

done

echo "STEP 8 DONE AT: "; date
####################################################################
#
# STEP 8.2 Calculate contig coverage and extract unassembled reads

module load java bbmap

samtools=/share/lemaylab-backedup/milklab/programs/samtools-1.9/samtools

for file in $output_dir_flash/*..extendedFrags.fastq
do
	STEM=$(basename "$file" ..extendedFrags.fastq)

	# Align reads with bbwrap.sh
	# bbwrap location: /software/bbmap/37.68/static/bbwrap.sh
	bbwrap.sh ref=$megahit_outdir/${STEM}_assembled/final.contigs.fa \
	in=$output_dir_dup/${STEM}.R1_dup.fastq,$file \
	in2=$output_dir_dup/${STEM}.R2_dup.fastq \
	out=$megahit_outdir/${STEM}_aln_sam.gz \
	kfilter=22 subfilter=15 maxindel=80

	# Output per contig coverage to cov.txt with pileup.sh
	# pileup location: /software/bbmap/37.68/static/pileup.sh
	pileup.sh in=$megahit_outdir/${STEM}_aln_sam.gz out=$megahit_outdir/${STEM}_cov.txt
done

echo "STEP 8.2 DONE AT: "; date

