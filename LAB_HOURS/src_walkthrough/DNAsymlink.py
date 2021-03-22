# python
import os
files=os.listdir("/data/class/ecoevo283/public/RAWDATA/DNAseq")
for f in files:
	if f.endswith('.fq.gz'):
		os.symlink("/data/class/ecoevo283/public/RAWDATA/DNAseq/"+f, "DNAseq/rawdata/"+f)

