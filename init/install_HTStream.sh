#!/bin/bash

# Installation instructions https://ibest.github.io/HTStream/#Installation

cd /share/lemaylab-backedup/milklab/programs/
wget https://github.com/ibest/HTStream/releases/download/v1.0.0-release/HTStream_1.0.0-release.tar.gz
tar xvf HTStream_1.0.0-release.tar.gz
rm HTStream_1.0.0-release.tar.gz

# organize all HTStream program to one folder 
mkdir HTStream_1.0.0
mv hts* HTStream_1.0.0/
