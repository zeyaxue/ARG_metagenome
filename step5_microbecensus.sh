#!/bin/bash
#SBATCH --mail-user=zhxue@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=MicrobeCensus
#SBATCH --error=MC.err
#SBATCH --time=5-00:00:00
#SBATCH --mem=500GB

# MicrobeCensus location
mc_location=/share/lemaylab-backedup/milklab/programs/MicrobeCensus-1.1.1/microbe_census/bin/run_microbe_census.py 


####################################################################
#
# STEP 5: Normalize for sample average genome size and RPKG
# The MicrobeCensus help page: https://github.com/snayfach/MicrobeCensus

echo "NOW STARTING NORMALIZATION WITH MicrobeCensus AT: "; date

output_dir_flash=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2-4_trim_fastuniq_flash/step4_flash
#mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step5_MC_test
output_dir_mc=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step5_MC_test

# change dir for writing temporary files
export TMPDIR=$output_dir_mc
# Add the numpy path to $PATH
export PATH="/home/xzyao/.local/bin:$PATH"

# Take output from step4 flash of the step2-4_trim_fastuniq_flash workflow
for file in $output_dir_flash/*..extendedFrags.fastq
do
	STEM=$(basename "${file}" ..extendedFrags.fastq)

	# -h for help
	# -t thread number
	$mc_location $file $output_dir_mc/${STEM}_mc.txt -t 15
done
