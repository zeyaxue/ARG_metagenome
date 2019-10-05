starting_files_location=/share/lemaylab-backedup/Zeya/raw_data/test_dataset

#/share/lemaylab-backedup/Zeya/programs/seqtk/seqtk/seqtk sample -s100 $starting_files_location/step_1_BMTagger_output/5052.R1_nohuman.fastq 1000 > $starting_files_location/step_1_BMTagger_output/5052.R1_nohuman_1000reads.fastq
/share/lemaylab-backedup/Zeya/programs/seqtk/seqtk/seqtk sample -s100 $starting_files_location/step_1_BMTagger_output/5052.R2_nohuman.fastq 1000 > $starting_files_location/step_1_BMTagger_output/5052.R2_nohuman_1000reads.fastq
 

