#!/bin/bash

####################################################################
#
# STEP 8. Assemble reads into contigs with megaHIT

echo "NOW STARTING ASEEMBLY WITH MEGAHIT AT: "; date

output_dir_flash=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step4_flash
output_dir_dup=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step3_fastuniq
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step8_megahit_nomerg
megahit_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step8_megahit_nomerg

megahit=/share/lemaylab-backedup/milklab/programs/MEGAHIT-1.2.9-Linux-x86_64-static/bin/megahit


# assemble with both single (flash assembled) and paired end reads input (after fastuniq deduplicate)
for file in $output_dir_flash/*.extendedFrags.fastq
do
	STEM=$(basename "$file" .extendedFrags.fastq)

	if [ -f $megahit_outdir/${STEM}_assembled/final.contigs.fa ]
	then
		echo "$megahit_outdir/${STEM}_assembled/final.contigs.fa exist"
	else	
		# usage instruction at https://github.com/voutcn/megahit & http://www.metagenomics.wiki/tools/assembly/megahit
		# use 70% memory and 20 threads
		$megahit -1 $output_dir_dup/${STEM}_R1_dup.fastq  -2 $output_dir_dup/${STEM}_R2_dup.fastq \
		-m 0.7 -t 20 \
		-o $megahit_outdir/${STEM}_assembled
	fi	
done

mv log $megahit_outdir/log

echo "STEP 8 DONE AT: "; date

