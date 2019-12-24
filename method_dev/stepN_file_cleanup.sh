#!/bin/bash

########################################################################################################################
# 
# DEFINE RUN FOLDER
run_dir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043
########################################################################################################################

rm $run_dir/unzipped

for file in $run_dir/step_1_BMTagger_output/*fastq
do 
	gzip $file
done	

for file in $run_dir/step2_trim/*fastq
do 
	gzip $file
done

