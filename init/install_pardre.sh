##!/bin/bash

# I downloaded the zip file to my local computer
# transfer the downloaded zip file to spitfire
scp ~/Downloads/ParDRe-rel2.2.5.tar.gz xzyao@spitfire.genomecenter.ucdavis.edu:/share/lemaylab-backedup/milklab/programs

cd /share/lemaylab-backedup/milklab/programs
tar -xvf ParDRe-rel2.2.5.tar.gz 

rm ParDRe-rel2.2.5.tar.gz 
cd ParDRe-rel2.2.5/
make
