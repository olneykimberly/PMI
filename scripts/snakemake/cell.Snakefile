import os

configfile: "cell_config.json"

cellranger_path = "/research/labs/neurology/fryer/m239830/tools/cellranger-6.1.1/bin/cellranger"
cellbender_path = "cellbender"

#ruleorder: cellranger > cellbender
rule all:
        input:
               # expand("{sample}/",sample = config["sample_names"]),
                expand(config["cellranger_dir"]+"scRNA/{sample}/", sample = config["sample_names"]),
                expand(config["cellranger_dir"] + "scRNA/web_summaries/{sample}_web_summary.html", sample=config["sample_names"]),
                expand(config["cellbender_dir"]+"scRNA/{sample}/", sample = config["sample_names"])



#------------------------------
# alignment
#------------------------------
rule cellranger:
        output:
                counts = (directory(config["cellranger_dir"]+"scRNA/{sample}/")),
                web_cp = (config["cellranger_dir"]+"scRNA/web_summaries/{sample}_web_summary.html"),
        params:
                cellranger = cellranger_path,
                id = lambda wildcards: config[wildcards.sample]["ID"],
                path = lambda wildcards: config[wildcards.sample]["fq_path"],
        shell:
                """
                {params.cellranger} count --id={params.id} --sample={params.id} --fastqs={params.path} --transcriptome=/research/labs/neurology/fryer/projects/references/mouse/refdata-gex-mm10-2020-A/ --localcores=16 --localmem=50 || true;
                mv {params.id}/ {output.counts};
                cp {output.counts}/outs/web_summary.html {output.web_cp}
                """

# $sample is the sampleID (e.g. 11-87_BR)
# --fastqs is path to the snRNAseq fastq files
# --transcriptome is the path to the human genome directory. This was created in a prior step.
# --include-introns includes unspliced transcripts.  Ideal for single nucleus RNAseq.
# --localcores will restrict cellranger to 16 cores
# --localmem will restrict cellranger to 50G memory

#------------------------------
# remove ambient cells
#------------------------------

rule cellbender:
        input:
            rules.cellranger.output.counts
        output:
            filtered = (directory(config["cellbender_dir"]+"scRNA/{sample}/"))
        params:
            id = lambda wildcards: config[wildcards.sample]["ID"],
        shell:
            """
            mkdir {output.filtered};
            sh cell_cellbender.sh {params.id} || true
            """
# --cuda: flag if using GPU
# --expected-cells: Base this on either the number of cells expected a priori from the experimental design, or if this is not known, base this number on the UMI curve as shown below, where the appropriate number would be 5000. Pick a number where you are reasonably sure that all droplets to the left on the UMI curve are real cells.
# --total-droplets-included: Choose a number that goes a few thousand barcodes into the “empty droplet plateau”. Include some droplets that you think are surely empty. But be aware that the larger this number, the longer the algorithm takes to run (linear). See the UMI curve below, where an appropriate choice would be 15,000. Every droplet to the right of this number on the UMI curve should be surely-empty. (This kind of UMI curve can be seen in the web_summary.html output from cellranger count.)
# --fpr: A value of 0.01 is generally quite good, but you can generate a few output count matrices and compare them by choosing a few values: 0.01 0.05 0.1
# --epochs: 150 is typically a good choice. Look for a reasonably-converged ELBO value in the output PDF learning curve (meaning it looks like it has reached some saturating value). Though it may be tempting to train for more epochs, it is not advisable to over-train, since this increases the likelihood of over-fitting. (We regularize to prevent over-fitting, but training for more than 300 epochs is too much.)
# NOTE: total_droplets must be an integer greater than the input expected_cell_count, which is 10000.

