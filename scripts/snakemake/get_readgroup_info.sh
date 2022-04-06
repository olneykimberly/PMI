#!/bin/bash

# change directory
cd /research/labs/neurology/fryer/projects/PMI/scRNA

# create file with list of R1 samples
ls -1 | grep _R1_ > R1Samples_scRNA.txt

# change directory 

# loops through list and print first line
touch sampleReadInfo_scRNA.txt
for sample in `cat R1Samples_scRNA.txt`; do
    #printf "${sample}\t"
    zcat ${sample} | head -1 >> sampleReadInfo_scRNA.txt	
done;

mv R1Samples_scRNA.txt  /research/labs/neurology/fryer/shared/PMI/scripts/snakemake/R1Samples_scRNA.txt
mv sampleReadInfo_scRNA.txt /research/labs/neurology/fryer/shared/PMI/scripts/snakemake/sampleReadInfo_scRNA.txt

cd /research/labs/neurology/fryer/shared/PMI/scripts/snakemake/
paste -d "\t" R1Samples_scRNA.txt sampleReadInfo_scRNA.txt > sampleReadGroupInfo_scRNA.txt
rm R1Samples_scRNA.txt
rm sampleReadInfo_scRNA.txt


# change directory
cd /research/labs/neurology/fryer/projects/PMI/snRNA

# create file with list of R1 samples
ls -1 | grep _R1_ > R1Samples_snRNA.txt

# change directory 

# loops through list and print first line
touch sampleReadInfo_snRNA.txt
for sample in `cat R1Samples_snRNA.txt`; do
    #printf "${sample}\t"
    zcat ${sample} | head -1 >> sampleReadInfo_snRNA.txt
done;

mv R1Samples_snRNA.txt  /research/labs/neurology/fryer/shared/PMI/scripts/snakemake/R1Samples_snRNA.txt
mv sampleReadInfo_snRNA.txt /research/labs/neurology/fryer/shared/PMI/scripts/snakemake/sampleReadInfo_snRNA.txt

cd /research/labs/neurology/fryer/shared/PMI/scripts/snakemake/
paste -d "\t" R1Samples_snRNA.txt sampleReadInfo_snRNA.txt > sampleReadGroupInfo_snRNA.txt
rm R1Samples_snRNA.txt
rm sampleReadInfo_snRNA.txt
