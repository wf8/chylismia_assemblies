#!/bin/bash

for seq in "ADH.fasta" "ETS.fasta" "ITS.fasta" "PgiC.fasta" "LFY.fasta" "WAXY.fasta"
do
    bwa index $seq
done

