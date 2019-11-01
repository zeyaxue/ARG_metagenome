#!/usr/bin/python

from make_RPKG_normtab import make_RPKG_normtab

make_RPKG_normtab(mcfp='5007_mc.txt', 
					  lenfp='megares_modified_database_v2_GeneLen_org.tsv', 
					  countfp='5007_gene.tsv', 
					  outfp='5007_norm.tsv')