#!/bin/bash 

run_dir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043

########################################################################################################################
#
# STEP 6: Align to MEGARes database with bwa

echo "NOW STARTING ALIGNMENT TO MEGARES_v2 WITH BWA AT: "; date

# Set input and output file paths
dup_outdir=$run_dir/step3_fastuniq

mkdir $run_dir/step6_megares_bwa
megares_outdir=$run_dir/step6_megares_bwa
# megares db including both drug, metal and biocide resistance genes
megares_dir=/share/lemaylab-backedup/milklab/database/megares_v2/

# Make sure bash knows where to look for softwares 
# Location and version of bwa module: /software/bwa/0.7.16a/lssc0-linux/bwa
module load bwa 

for file in $dup_outdir/*_R1_dup.fastq
do
	STEM=$(basename "$file" _R1_dup.fastq)
	
	file1=$file
	file2=$dup_outdir/${STEM}_R2_dup.fastq

	# use the bwa mem method for fastest speed and accuracy
	# BWA aligner manual: http://bio-bwa.sourceforge.net/bwa.shtml
	# -t: thread
	bwa mem -t 15 $megares_dir/megares_modified_database_v2.00.fasta $file $file2 > $megares_outdir/${STEM}_align.sam
done

echo "STEP 6 DONE AT: "; date
########################################################################################################################