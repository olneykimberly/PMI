#!/bin/bash

# change directory
cd /research/labs/neurology/fryer/projects/PMI/2024_snRNA/

# create file with list of R1 samples
awk '{print $2}' MD5.txt | grep _R1_ > R1Samples_snRNA.txt

# change directory 

# loops through list and print first line
touch sampleReadInfo_snRNA.txt
for sample in `cat R1Samples_snRNA.txt`; do
    #printf "${sample}\t"
    zcat ${sample} | head -1 >> sampleReadInfo_snRNA.txt	
done;

mv R1Samples_snRNA.txt  /research/labs/neurology/fryer/m239830/PMI/scripts/R1Samples_snRNA.txt
mv sampleReadInfo_snRNA.txt /research/labs/neurology/fryer/m239830/PMI/scripts/sampleReadInfo_snRNA.txt

cd /research/labs/neurology/fryer/m239830/PMI/scripts/
paste -d "\t" R1Samples_snRNA.txt sampleReadInfo_snRNA.txt > sampleReadGroupInfo_snRNA.txt
rm R1Samples_snRNA.txt
rm sampleReadInfo_snRNA.txt

