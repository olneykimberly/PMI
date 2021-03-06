#!/usr/bin/python3

# create a new output file
outfile = open('cell_config.json', 'w')

# get all, kidney, brain and blood sample names
allSamples = list()
type_LBD = list()
LDB_type = list()
sex = list()
read = ["R1", "R2"]
numSamples = 0

with open('sampleReadGroupInfo_scRNA.txt', 'r') as infile:
    for line in infile:
        numSamples += 1

        line = line.replace(".", "_")
        split = line.split()
        sampleAttributes = split[0].split('_') # rep1_PS19_Fresh_S2_L008_R1_001.fastq.gz
        # create a shorter sample name
        stemName = sampleAttributes[0] + '_' + sampleAttributes[1] + '_' + sampleAttributes[2] + '_' + sampleAttributes[3]
        allSamples.append(stemName)

# create header and write to outfile
header = '''{{
    "Commment_Input_Output_Directories": "This section specifies the input and output directories for scripts",
    "rawReads" : "/research/labs/neurology/fryer/projects/PMI/scRNA",
    "counts" : "../../counts/",
    "cellranger_dir" : "../../cellranger/",
    "cellbender_dir" : "../../cellbender/",
    "results" : "../../results/",
    "rObjects" : "../../rObjects/",
    "fastq_path" : "/research/labs/neurology/fryer/projects/PMI/scRNA/",

    "Comment_Reference" : "This section specifies the location of the Sus scrofa, Ensembl reference genome",
    "mm10.fa" : "/research/labs/neurology/fryer/projects/references/mouse/refdata-gex-mm10-2020-A/",
    "genes.gtf" : "/research/labs/neurology/fryer/projects/references/mouse/refdata-gex-mm10-2020-A/genes",

    "Comment_Sample_Info": "The following section lists the samples that are to be analyzed",
    "sample_names": {0},
    "read": {1},
'''
outfile.write(header.format(allSamples, read))

# config formatting
counter = 0
with open('sampleReadGroupInfo_scRNA.txt', 'r') as infile:
    for line in infile:
        counter += 1
        # store sample name and info from the fastq file
        split = line.split()
        base = split[0]
        base = base.replace(".fastq.gz", "")
        sampleName1 = base
        sampleName2 = sampleName1.replace("R1","R2")
        base = base.replace("_R1_", "")
        sampleInfo = split[1]

        # make naming consistent, we will rename using only underscores (no hyphens)
        line = line.replace(".", "_")
        split = line.split()
        sampleAttributes = split[0].split('_')  # PS19_3_hr_S6_L006_I1_001.fastq.gz
        # uniqueNum-number_sequencer_lane_read.fastq.gz

        # create a shorter sample name
        stemName = sampleAttributes[0] + '_' + sampleAttributes[1] + '_' + sampleAttributes[2] + '_' + sampleAttributes[3]
        stemID = sampleAttributes[0] + '_' + sampleAttributes[1] + '_' + sampleAttributes[2]
        shortName1 = stemName + '_R1'
        shortName2 = stemName + '_R2'

        # break down fastq file info
        # @A00127:312:HVNLJDSXY:2:1101:2211:1000
        # @<instrument>:<run number>:<flowcell ID>:<lane>:<tile>:<x-pos>:<y-pos>
        sampleInfo = sampleInfo.split(':')
        instrument = sampleInfo[0]
        runNumber = sampleInfo[1]
        flowcellID = sampleInfo[2]

        lane = sampleInfo[3]
        ID = stemID  # ID tag identifies which read group each read belongs to, so each read group's ID must be unique
        SM = stemName  # Sample
        PU = flowcellID + "." + lane  # Platform Unit
        LB = stemName

        out = '''
    "{0}":{{
        "fq_path": "/research/labs/neurology/fryer/projects/PMI/scRNA/",
        "fq1": "{1}",
        "fq2": "{2}",
        "shortName1": "{3}",
        "shortName2": "{4}",
        "ID": "{5}",
        "SM": "{5}",
        "PU": "{6}",
        "LB": "{7}",
        "PL": "Illumina"
        '''
        outfile.write(out.format(stemName, sampleName1, sampleName2, shortName1, shortName2, stemName, PU, LB))
        if (counter == numSamples):
            outfile.write("}\n}")
        else:
            outfile.write("},\n")
outfile.close()
