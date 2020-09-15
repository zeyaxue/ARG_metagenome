#!/bin/bash

run_dir=/home/AMR_metagenome/processed_data/Novaseq_072rerun


####################################################################
#
# STEP 5: Normalize for sample average genome size and RPKG
# The MicrobeCensus help page: https://github.com/snayfach/MicrobeCensus

echo "NOW STARTING NORMALIZATION WITH MicrobeCensus AT: "; date

## Set input and output file paths  
dup_outdir=$run_dir/step3_fastuniq
mkdir $run_dir/step5_MicrobeCensus
mc_outdir=$run_dir/step5_MicrobeCensus
 

# MicrobeCensus location
#microbecensus=/software/run_microbe_census_nomodule.py
microbecensus=/software/MicrobeCensus-1.1.1/run_microbe_census.py 
# External RAPsearch2 v2.15 binary. I would like to have the binary NOT in the xzyao/.local home directory
# because the home directory gets wiped clean every time I log out?
RAPSEARCH=/software/MicrobeCensus-1.1.1/microbe_census/bin/rapsearch_Linux_2.15

for file in $dup_outdir/7092_R1_dup.fastq
do
	STEM=$(basename "$file" _R1_dup.fastq)

	if [ -f $mc_outdir/${STEM}_allreads_mc.txt ]
	then
		echo "$file exist"
	else 
		echo "Processing sample $file now" 
	
		#export PATH="/home/xzyao/miniconda3/bin:$PATH"
		#export PATH="/home/xzyao/.local/bin:$PATH"
		# change dir for writing temporary files
		#export TMPDIR=$mc_outdir
		
		file2=$dup_outdir/${STEM}_R2_dup.fastq

		# -h for help
		# -l read length to cut at, should be 150 for Novaseq paired end samples
		# -t thread number for rapsearch, microbecensus only uses 1 thread
		# -n number of reads to sample from seqfile and use for AGS estimation 
		## set at 77 million reads to use all reads (77 million reads = F + R)
		python $microbecensus $file,$file2 $mc_outdir/${STEM}_allreads_mc.txt \
		-r $RAPSEARCH \
		-l 150 -t 20 -n 77000000 #change per run 
	fi
done
