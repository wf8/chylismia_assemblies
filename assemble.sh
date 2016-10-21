#!/bin/bash
#for index in 45 53 33
for index in 55
do
    echo "Uncompressing index: $index"
    gunzip 150PE/Index_${index}_*R1*.fastq.gz
    gunzip 150PE/Index_${index}_*R2*.fastq.gz
    echo "Assembling index: $index"
    cd utilities/Fast-Plast/
    ./run_fast-plast.sh ../../150PE/Index_${index}_*R1*.fastq ../../150PE/Index_${index}_*R2*.fastq $index
    mkdir ../../assemblies/$index
    mv $index* ../../assemblies/$index/
    cd ../../
    echo "Re-compressing index: $index"
    gzip 150PE/Index_${index}_*R1*.fastq
    gzip 150PE/Index_${index}_*R2*.fastq
done
