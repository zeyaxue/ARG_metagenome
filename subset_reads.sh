#!/bin/bash

# Take input directory 
read -p "Enter input directory: " indir
# Enter output directory
read -p "Enter output directory: " outdir

#/share/lemaylab-backedup/Zeya/programs/seqtk/seqtk/seqtk sample -s100 $starting_files_location/step_1_BMTagger_output/5052.R1_nohuman.fastq 1000 > $starting_files_location/step_1_BMTagger_output/5052.R1_nohuman_1000reads.fastq
#/share/lemaylab-backedup/Zeya/programs/seqtk/seqtk/seqtk sample -s100 $starting_files_location/step_1_BMTagger_output/5052.R2_nohuman.fastq 1000 > $starting_files_location/step_1_BMTagger_output/5052.R2_nohuman_1000reads.fastq
 

# or used the head command
for file in $indir/500*.fastq 
do
	STEM=$(basename "${file}" .fastq)
	head -n 4000 $file > $outdir/${STEM}_1000reads.fastq
done
