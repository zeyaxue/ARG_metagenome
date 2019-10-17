#!/bin/bash

# Miniconda 3 is installed into this location: /home/xzyao/miniconda3
# Add this path to the environmentals variable $PATH so conda command can be called
# Note: this is only changing the PATH temporarily. 
# For permant change, one can add the command to .bash_profile (but I won't do in this case to not mess with other scripts)
export PATH="/home/xzyao/miniconda3/bin:$PATH"

# install trimmomatic version 0.39-1
conda install trimmomatic # from bioconda channel
# Location is /home/xzyao/miniconda3/pkgs/trimmomatic-0.39-1
# install trimmomatic dependency 
conda install openjdk # from conda-forge
