#!/bin/bash

# I followed the link below to install minoconda
# https://bioconda.github.io/user/install.html#set-up-channels
# I downloaded and installed the minoconda to my directory on spitfire
#cd /share/lemaylab-backedup/Zeya

#wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
#sh Miniconda3-latest-Linux-x86_64.sh 

# Miniconda 3 is installed into this location: /home/xzyao/miniconda3
# Add this path to the environmental variable $PATH so conda command can be called
# Note: this is only changing the PATH temporarily. 
# For permant change, one can add the command to .bash_profile (but I won't do in this case to not mess with other scripts)
export PATH="/home/xzyao/miniconda3:$PATH"

# set up channels, add bioconda channel and other dependencies
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge