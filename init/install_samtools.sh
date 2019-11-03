#!/bin/bash 

cd /share/lemaylab-backedup/milklab/programs/
wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2

tar xvjf samtools-1.9.tar.bz2

cd samtools-1.9 && make -j && cd ..