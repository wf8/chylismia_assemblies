#!/bin/bash

#for seq in "ADH.fasta" "ETS.fasta" "ITS.fasta" "PgiC.fasta" "LFY.fasta" "WAXY.fasta"
for seq in "ATP6" "trnI" "ORF224" "ORF250" "ORF454" "NAD5" "NAD4" "NAD6" "NAD7" "RPS13" "COXIII" "ATP8" "ORF206" "RPS14" "NAD3" "NAD2" "S3" "trnS" "MatR" "ATP9" "ATP1" "COXI" "CYTB" "26S" "18S"
do
    bwa index ${seq}.fasta
done

