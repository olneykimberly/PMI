#!/bin/bash

#module load python
#conda activate cellbender_v0.3.0
# Read each sample ID from the file sample_list.txt
while IFS= read -r sampleID; do
    # Execute the command for each sample ID
    ptrepack --complevel 5 "${sampleID}/${sampleID}_cellbender_filtered.h5:/matrix" "${sampleID}/${sampleID}_cellbender_filtered_seurat.h5:/matrix"
done < sample_list.txt
