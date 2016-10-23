#!/bin/bash

for index in 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 # 33
do
do

    echo "Uncompressing index: $index"
    gunzip 150PE/Index_${index}_*R1*.fastq.gz
    gunzip 150PE/Index_${index}_*R2*.fastq.gz

    # exclude single copy loci with too low coverage: "PgiC" "LFY" "WAXY" "ADH"
    # make reference assemblies of nuclear rDNA and mitochondrial genes:
    for ref in "ETS" "ITS" "26S" "18S" "CYTB" "MatR" "ATP6" "trnI" "ORF224" "ORF250" "ORF454" "NAD5" "NAD4" "NAD6" "NAD7" "RPS13" "COXIII" "ATP8" "ORF206" "RPS14" "NAD3" "NAD2" "S3" "trnS" "ATP9" "ATP1" "COXI"
    
        reference="reference_genomes/${ref}.fasta"
        mkdir assemblies/bwa/$ref
        output_dir="assemblies/bwa/${ref}/"
        
        echo "Assembling index: $index"
        
        echo "Filtering adapter sequences..."
        java -classpath utilities/Trimmomatic-0.36/trimmomatic-0.36.jar org.usadellab.trimmomatic.TrimmomaticPE -threads 4 -phred33 150PE/Index_${index}_*R1*.fastq 150PE/Index_${index}_*R2*.fastq ${index}_trimmed_P1.fq ${index}_trimmed_U1.fq ${index}_trimmed_P2.fq ${index}_trimmed_U2.fq ILLUMINACLIP:utilities/Fast-Plast/bin/NEB-PE.fa:1:30:10 SLIDINGWINDOW:10:20 MINLEN:40
        
        echo "Mapping reads with bwa..."
        bwa mem $reference ${index}_trimmed_P1.fq ${index}_trimmed_P2.fq > ${index}.sam
        
        echo "Coverting SAM to BAM..."
        samtools view -bS ${index}.sam > ${index}.bam
        
        echo "Sorting reads..."
        samtools sort ${index}.bam ${index}_sorted
        
        echo "Determining read depth..."
        samtools depth ${index}_sorted.bam > ${index}_read_depth.tsv
        
        echo "Making BAM pileup, generating consensus FASTA sequence..."
        samtools mpileup -uf $reference ${index}_sorted.bam | bcftools view -cg - | vcfutils.pl vcf2fq > ${index}.fastq
        seqtk seq -A ${index}.fastq > ${index}.fasta
        
        echo "Cleaning up..."
        rm ${index}_trimmed_*
        mkdir ${output_dir}${index}
        mv ${index}* ${output_dir}${index}
    
    done

    echo "Re-compressing index: $index"
    gzip 150PE/Index_${index}_*R1*.fastq
    gzip 150PE/Index_${index}_*R2*.fastq

done

# Illumina adapter sequences were removed and the raw sequence reads were quality filtered using Trimmomatic v0.36 (CITE). Reads were trimmed when the average phred quality score in a 10-bp sliding window was less than 20. Reads that were less than 40 bp or that did not survive the filtering process in both forward and reverse directions were excluded.

