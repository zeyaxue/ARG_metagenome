#!/bin/bash
########################################################################################################################
## install from source in the active conda environment
export PATH="/home/xzyao/miniconda3/bin:$PATH"
source activate ARG-py37

cd /share/lemaylab-backedup/milklab/programs/MicrobeCensus-1.1.1

# change mode line to 0o555) & 0o7777
nano setup.py 
python setup.py install 

# test the installation 
cd tests/
python tests/test_microbe_census.py  ## Output temp files are open...



########################################################################################################################
# Didn't work 

# install with conda 
export PATH="/home/xzyao/miniconda3/bin:$PATH"
source activate ARG-py37

conda install -c bioconda microbecensus

#(ARG-py37) xzyao@spitfire:/share/lemaylab-backedup/milklab/programs$ conda install -c bioconda microbecensus
#
#Collecting package metadata (current_repodata.json): done
#Solving environment: failed with current_repodata.json, will retry with next repodata source.
#Initial quick solve with frozen env failed.  Unfreezing env and trying again.
#Solving environment: failed with current_repodata.json, will retry with next repodata source.
#Collecting package metadata (repodata.json): done
#Solving environment: failed
#Initial quick solve with frozen env failed.  Unfreezing env and trying again.
#Solving environment: failed
#
#UnsatisfiableError: The following specifications were found
#to be incompatible with the existing python installation in your environment:
#
#  - microbecensus -> python[version='>=2.7,<2.8.0a0']
#
#If python is on the left-most side of the chain, that's the version you've asked for.
#When python appears to the right, that indicates that the thing on the left is somehow
#not available for the python version you are constrained to.  Your current python version
#is (python=3.7).  Note that conda will not change your python version to a different minor version
#unless you explicitly specify that.
#
#The following specifications were found to be incompatible with each other:
#
#
#
#Package certifi conflicts for:
#microbecensus -> numpy -> mkl_random[version='>=1.0.2,<2.0a0'] -> mkl-service[version='>=2,<3.0a0'] -> six -> python[version='>=2.7,<2.8.0a0'] -> pip -> wheel -> setuptools -> certifi[version='>=2016.09']
#python=3.7 -> pip -> wheel -> setuptools -> certifi[version='>=2016.09']
#Package setuptools conflicts for:
#python=3.7 -> pip -> wheel -> setuptools
#microbecensus -> numpy -> mkl_random[version='>=1.0.2,<2.0a0'] -> mkl-service[version='>=2,<3.0a0'] -> six -> python[version='>=2.7,<2.8.0a0'] -> pip -> wheel -> setuptools
#Package wheel conflicts for:
#microbecensus -> numpy -> mkl_random[version='>=1.0.2,<2.0a0'] -> mkl-service[version='>=2,<3.0a0'] -> six -> python[version='>=2.7,<2.8.0a0'] -> pip -> wheel
#python=3.7 -> pip -> wheel
#Package pip conflicts for:
#microbecensus -> numpy -> mkl_random[version='>=1.0.2,<2.0a0'] -> mkl-service[version='>=2,<3.0a0'] -> six -> python[version='>=2.7,<2.8.0a0'] -> pip
#python=3.7 -> pip



########################################################################################################################
# Didn't work 
# below is the directly downloading method

cd /share/lemaylab-backedup/milklab/programs/
wget https://github.com/snayfach/MicrobeCensus/archive/v1.1.1.tar.gz

# unpack and go to the microbecensus directory
tar -xvf v1.1.1.tar.gz 
FAILED (errors=1)
rm v1.1.1.tar.gz 
cd MicrobeCensus-1.1.1

# must include --prefix to install. This will install for the user to use. Others can not run it 
# I also can not install as a superuser
python setup.py install --prefix=/home/xzyao/microbe_census

# Move the folder to /share/lemaylab-backedup/milklab/programs/MicrobeCensus-1.1.1
cp /home/xzyao/microbe_census/ ./ -r

# Test to see if succesfully installed
cd microbe_census/
python tests/test_microbe_census.py # --> error msg Could not import module 'numpy'

#####(1) so I try to install numpy####
# install numpy
pip3 install numpy # the workstation only has pip3
python3 tests/test_microbe_census.py # --> error msg:  FAILED (errors=1)
# Try running python3 with set up 
cd ..
python3 setup.py install --prefix=/home/xzyao/microbe_census3 # --> error msg SyntaxError: invalid token at line 12

#####(2)It seems numpy run with python2 but I only have pip3
# install pip (https://pip.pypa.io/en/stable/installing/)
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py --user # installed location:/home/xzyao/.local/lib/python2.7/site-packages/pip/
# Add the installed directory to PATH
export PATH="/home/xzyao/.local/bin:$PATH"
# install numpy module (https://www.scipy.org/install.html)
python -m pip install numpy --user # msg: Successfully installed numpy-1.16.5
# check if microbcensus work 
python tests/test_microbe_census.py # yay! msg: Ran 3 tests in 57.854s OK


####(3) to run microbecensus
python bin/run_microbe_census.py # plus arguments
