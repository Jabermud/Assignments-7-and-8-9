#!/bin/bash
#SBATCH --job-name=dna_align      ## Name of the job.
#SBATCH -A SEYEDAM_LAB       ## account to charge 
#SBATCH -p standard          ## partition/queue name
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --array=1-12         ## number of tasks to launch
#SBATCH --cpus-per-task=2    ## number of cores the job needs
#SBATCH --output=dna_align-%J.out ## output log file
#SBATCH --error=dna_align-%J.err ## error log file

module load bwa/0.7.8
module load samtools/1.10
module load bcftools/1.10.2
module load python/3.8.0
module load gatk/4.1.9.0
module load picard-tools/1.87
module load java/1.8.0
module load hisat2/2.2.1


inpath="/data/class/ecoevo283/jabermud/lab_hours/DNAseq/rawdata/"
file=$inpath"prefixes.txt" # prefix file
ref="/data/class/ecoevo283/erebboah/ref/dmel-all-chromosome-r6.13.fasta"
prefix=`head -n $SLURM_ARRAY_TASK_ID  ${file} | tail -n 1`

# alignments
bwa mem -t 2 -M $ref ${inpath}data/${prefix}_1.fq.gz ${inpath}data/${prefix}_2.fq.gz | samtools view -bS - > ${inpath}mapped/${prefix}.bam
samtools sort ${inpath}mapped/${prefix}.bam -o ${inpath}mapped/${prefix}.sort.bam
rm ${inpath}mapped/${prefix}.bam

# GATK likes readgroups
java -jar  /opt/apps/picard-tools/1.87/AddOrReplaceReadGroups.jar I=${inpath}mapped/${prefix}.sort.bam O=${inpath}mapped/${prefix}.RG.bam SORT_ORDER=coordinate RGPL=illumina RGPU=D109LACXX RGLB=Lib1 RGID=${prefix:0:5} RGSM=${prefix:0:5} VALIDATION_STRINGENCY=LENIENT
samtools index ${inpath}mapped/${prefix}.RG.bam
