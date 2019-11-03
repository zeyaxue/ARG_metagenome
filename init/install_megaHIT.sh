#!/bin/bash

#https://github.com/voutcn/megahit

cd /share/lemaylab-backedup/milklab/programs/
wget https://github.com/voutcn/megahit/releases/download/v1.2.9/MEGAHIT-1.2.9-Linux-x86_64-static.tar.gz

tar zvxf MEGAHIT-1.2.9-Linux-x86_64-static.tar.gz
cd MEGAHIT-1.2.9-Linux-x86_64-static/bin/

./megahit --test  # run on a toy dataset