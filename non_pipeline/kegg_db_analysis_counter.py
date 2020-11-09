#!/usr/bin/env python
# Zeya Xue on 11/5/2020
#
# Python script created to sort through DIAMOND annotation results
# and create one master output table that show KEGG gene totals
# for every sample.

##############################################################################
#
# Usage:
#
# -I		infile			DIAMOND annotation results file(s)
#
# -O 		output			Name of output file formatted to have the sample 
# 								name as the column name and the gene id 
#								name as the row

# Example input file:
#  A00351:313:H2KHHDSXY:2:2555:17906:2033  ruj:E5Z56_08445 93.4    61      4       0	239     57      1       61      1.2e-26 125.2
#  A00351:313:H2KHHDSXY:2:1453:7184:13839  rus:RBI_I00108  94.5    91      5       0	2       274     368     458     8.4e-41 172.2
#  
# Example results file:
#  ruj:E5Z56_08445 		3			
#  rus:RBI_I00108 		15					
#
# Example usage: python kegg_db_analysis_counter.py -I sample_kegg_diamond.txt -O sample_kegg_diamond.csv
#
##############################################################################
from sys import argv
import argparse
import re
from collections import Counter
import pandas as pd

# create flag arguments:
parser = argparse.ArgumentParser()

parser.add_argument("-I", "--infile", dest = "input", help = "input file", nargs='+') 		  # second flag argument
parser.add_argument("-O", "--output", dest = "output", help = "output file") 	  # third flag argument

args = parser.parse_args()

in_file = args.input 	# set second flag argument to a variable
out_file = args.output 	# set third flag argument to a variable

print("Input file: %s, Output file: %s") % (args.input, args.output)

genes = [] 									# create a blank list 
for file in in_file:
	with open(file, 'rU') as f:
		for line in f:
			x = re.split('[: \t]', line)		# split each row by special characters
			genes.append(x[1])					# append id names to blank list
counts = Counter(genes)

# write out the dictionary as a csv file
# help from https://stackoverflow.com/questions/18837262/convert-python-dict-into-a-dataframe
df = pd.DataFrame(counts.items(), columns=['Gene','Counts'], index=None) 
df.to_csv(out_file, sep=',', index=False)	