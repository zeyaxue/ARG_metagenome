#!/bin/bash

run_dir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq112


####################################################################
#
# STEP 5: Normalize for sample average genome size and RPKG
# The MicrobeCensus help page: https://github.com/snayfach/MicrobeCensus

echo "NOW STARTING NORMALIZATION WITH MicrobeCensus AT: "; date

## Set input and output file paths
flash_outdir=$run_dir/step4_flash
mkdir $run_dir/step5_MicrobeCensus_merged
mc_outdir=$run_dir/step5_MicrobeCensus_merged
 

# MicrobeCensus location
microbecensus=/share/lemaylab-backedup/milklab/programs/MicrobeCensus-1.1.1/scripts/run_microbe_census_nomodule.py
# External RAPsearch2 v2.15 binary. I would like to have the binary NOT in the xzyao/.local home directory
# because the home directory gets wiped clean every time I log out?
RAPSEARCH=/share/lemaylab-backedup/milklab/programs/MicrobeCensus-1.1.1/microbe_census/bin/rapsearch_Linux_2.15

for file in $flash_outdir/*.extendedFrags.fastq
do
	STEM=$(basename "$file" .extendedFrags.fastq)

	if [ -f $mc_outdir/${STEM}_mc.txt ]
	then
		echo "$file exist"
	else 
		echo "Processing sample $file now" 
	
		export PATH="/home/xzyao/miniconda3/bin:$PATH"
		export PATH="/home/xzyao/.local/bin:$PATH"
		# change dir for writing temporary files
		export TMPDIR=$mc_outdir
		

		# -h for help
		# -l read length to cut at, should be 150 for Novaseq paired end samples
		# -t thread number for rapsearch, microbecensus only uses 1 thread
		# -n number of reads to sample from seqfile and use for AGS estimation 
		## set at 77 million reads to use all reads (77 million reads = F + R)
		$microbecensus $file $mc_outdir/${STEM}_mc.txt \
		-r $RAPSEARCH \
		-l 150 -t 20 -n 100000000 #change per run 
	fi
done
