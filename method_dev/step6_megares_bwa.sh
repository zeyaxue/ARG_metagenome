#!/bin/bash 

####################################################################
#
# STEP 6: Align to MEGARes database with bwa

echo "NOW STARTING ALIGNMENT WITH DIAMOND AT: "; date

# megares db including both drug, metal and biocide resistance genes
megares_db=/share/lemaylab-backedup/milklab/database/megares_v2/megares_modified_database_v2.00.fasta

# Location and version of bwa module: /software/bwa/0.7.16a/lssc0-linux/bwa
# BWA aligner manual: http://bio-bwa.sourceforge.net/bwa.shtml
module load bwa 

output_dir_flash=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_trim_fastuniq_flash/step4_flash
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step6_megares_bwa
output_dir_megares=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step6_megares_bwa

for file in $output_dir_flash/*..extendedFrags.fastq
do
	STEM=$(basename "$file" ..extendedFrags.fastq) 

	# use the bwa mem method for fastest speed and accuracy
	bwa mem $megares_db $file > $output_dir_megares/${STEM}_align.sam

done

