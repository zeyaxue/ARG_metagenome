#!/bin/bash
#SBATCH --mail-user=zhxue@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=MicrobeCensus
#SBATCH --error=MC.err
#SBATCH --time=5-00:00:00
#SBATCH --mem=500GB


export PATH="/home/xzyao/miniconda3/bin:$PATH"
source activate ARG-py37

run_dir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043


####################################################################
#
# STEP 5: Normalize for sample average genome size and RPKG
# The MicrobeCensus help page: https://github.com/snayfach/MicrobeCensus

echo "NOW STARTING NORMALIZATION WITH MicrobeCensus AT: "; date

## Set input and output file paths
#
dup_outdir=$run_dir/step3_fastuniq
mc_outdir=$run_dir/step5_MicrobeCensus

# MicrobeCensus location
microbecensus=/share/lemaylab-backedup/milklab/programs/MicrobeCensus-1.1.1/scripts/run_microbe_census.py



# Take output from step4 flash of the step2-4_trim_fastuniq_flash workflow
for file in $dup_outdir/*_R1_dup.fastq
do
	echo "Processing sample $file now"

	export PATH="/home/xzyao/miniconda3/bin:$PATH"
	source activate ARG-py37
	# change dir for writing temporary files
	export TMPDIR=$mc_outdir

	STEM=$(basename "$file" _R1_dup.fastq)
	file2=$dup_outdir/${STEM}_R2_dup.fastq

	# -h for help
	# -t thread number
	$microbecensus $file,$file2 $mc_outdir/${STEM}_mc.txt 
done
