(**DID NOT WORK FOR ME!!!**)

#!/bin/bash
#SBATCH --job-name=ATAC_align ## Name of the job. 
#SBATCH -A ecoevo283 ##account to charge 
#SBATCH -p standard ## partition/queue name 
#SBATCH --array=1-24 ### number of tasks to launch, given hint below wc -l $file is helpful
#SBATCH --cpus-per-task=4 ## number of cores the job needs, can the programs you run make used of multiple cores?

module load bwa/0.7.8 
module load samtools/1.10 
module load bcftools/1.10.2

#Command used to generate prefixes for array.
#for i in ATACSeq/*_R1.fq.gz; do basename ${i} | sed 's/_R1.fq.gz//'; done >> ATAC_prefixes.txt
 
file="atac_prefixes.txt"
ref="ref/dmel-all-chromosome-r6.13.fasta"
prefix=`head -n $SLURM_ARRAY_TASK_ID $file | tail -n 1`
dir="ATACSeq_out"

# alignments
bwa mem -t 4 -M $ref ATACSeq/${prefix}_R1.fq.gz ATACSeq/${prefix}_R2.fq.gz | samtools view -bS - > $dir/$prefix.bam 
samtools sort $dir/$prefix.bam -o $dir/$prefix.sort.bam

