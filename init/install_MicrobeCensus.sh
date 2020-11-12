#!/bin/bash

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

##### so I try to install numpy####
module load pip
# install numpy module (https://www.scipy.org/install.html)
pip install numpy==1.16.5 -t /share/lemaylab-backedup/milklab/programs/MicrobeCensus-1.1.1/scripts
## msg: Successfully installed numpy-1.16.5
# check if microbcensus work 
python tests/test_microbe_census.py # yay! msg: Ran 3 tests in 57.854s OK


####(3) to run microbecensus
python bin/run_microbe_census.py # plus arguments

#### (4) make a script that does not require calling for modules
## i.e. module fucntions were directly coded within the script
cp /share/lemaylab-backedup/milklab/programs/MicrobeCensus-1.1.1/scripts/run_microbe_census.py /share/lemaylab-backedup/milklab/programs/MicrobeCensus-1.1.1/scripts/run_microbe_census_nomodule.py 
# I used nano to modify the script
