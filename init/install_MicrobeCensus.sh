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
