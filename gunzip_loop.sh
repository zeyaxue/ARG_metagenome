#!/bin/sh

#       0. Starting files location
starting_files_location=/share/lemaylab-backedup/Zeya/raw_data/NovaSeq043/tb957t8xg/Un_DTDB73/Project_DLZA_Nova043P_Alkan

unzipped_files_output=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/unzipped


for file in $starting_files_location/*fastq.gz
do
	STEM=$(basename "${file}" .gz)

	if [-e /$unzipped_files_output/"${STEM}".fastq]
	then 
		echo this file already exist and will not to rewrite
	else
		#gunzip -c "${file}" > /$unzipped_files_output/"${STEM}"
		echo it does not exist
  	fi		
done


