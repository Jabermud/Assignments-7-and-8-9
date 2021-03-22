# do some stuff from the command line firt
# get a list of all the fastq files in the entire path
# runme> find /data/class/ecoevo283/public/RAWDATA/RNAseq/RNAseq384plex_flowcell01/ -name "*.fastq.gz" >fastqs.txt
#
# create a table that will allow for sample name lookups..
# runme> cat /data/class/ecoevo283/public/RAWDATA/RNAseq/RNAseq384_SampleCoding.txt | cut -f1,12 | tail -n +2 >dict.txt
#
# python
import os
import re
import sys

### read in tab delimited sample# \t samplename
d = {}
with open("dict.txt") as FILEIN:
	for line in FILEIN:
		(key, val) = line.split()
		d[int(key)] = val

### make symlinks
for f in sys.stdin:
	f = f.strip('\n')
	if f.endswith('.fastq.gz') and "Undetermined" not in f:
		num=re.search("[0-9]+_",f).group(0).replace("_","")
		dir=re.search("_R[0-9]_",f).group(0).replace("_R1_","F").replace("_R2_","R")
		out="RNAseq/rawdata/"+ d[int(num)] + "_" + dir +".fq.gz"
		print(f,num,dir,out)
		os.symlink(f, out)

