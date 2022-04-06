configfile: "nucleus_config.json"

cellranger_path = "/research/labs/neurology/fryer/m239830/tools/cellranger-6.1.1/bin/cellranger"

ruleorder: cellranger > cellbender
rule all:
        input:
                expand(config["cellranger_dir"]+"snRNA/{sample}/", sample = config["sample_names"]),
                expand(config["cellranger_dir"] + "snRNA/web_summaries/{sample}_web_summary.html", sample=config["sample_names"]),
                expand(config["cellbender_dir"]+"snRNA/{sample}/", sample = config["sample_names"])

#------------------------------
# alignment
#------------------------------
rule cellranger:
        output:
                counts = (directory(config["cellranger_dir"]+"snRNA/{sample}/")),
                web_cp = (config["cellranger_dir"]+"snRNA/web_summaries/{sample}_web_summary.html"),
        params:
                cellranger = cellranger_path,
                id = lambda wildcards: config[wildcards.sample]["ID"],
                path = lambda wildcards: config[wildcards.sample]["fq_path"],
        shell:
                """
                {params.cellranger} count --id={params.id} --sample={params.id} --fastqs={params.path} --transcriptome=/research/labs/neurol
ogy/fryer/projects/references/mouse/refdata-gex-mm10-2020-A/ --include-introns --localcores=16 --localmem=50 || true;
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
            filtered = (directory(config["cellbender_dir"]+"snRNA/{sample}/"))
        params:
            id = lambda wildcards: config[wildcards.sample]["ID"],
        shell:
            """                                                                                                           
            mkdir {output.filtered};                                                                                      
            sh nucleus_cellbender.sh {params.id};
            mv .h5.pdf {params.id}.h5.pdf;
            mv .h5.log {params.id}.h5.log;
            mv .h5_FPR_0.05.h5 {params.id}.h5_FPR_0.05.h5;
            mv .h5_FPR_0.05_filtered.h5 {params.id}.h5_FPR_0.05_filtered.h5;
            mv .h5_cell_barcodes.csv {params.id}.h5_cell_barcodes.csv
            """
# --cuda: flag if using GPU
# --expected-cells: Base this on either the number of cells expected a priori from the experimental design, or if this is not known, base th is number on the UMI curve as shown below, where the appropriate number would be 5000. Pick a number where you are reasonably sure that alldroplets to the left on the UMI curve are real cells.
# --total-droplets-included: Choose a number that goes a few thousand barcodes into the ?~@~\empty droplet plateau?~@~]. Include some droplets that you think are surely empty. But be aware that the larger this number, the longer the algorithm takes to run (linear). See the UMI curve below, where an appropriate choice would be 15,000. Every droplet to the right of this number on the UMI curve should be surely-empty. (
# This kind of UMI curve can be seen in the web_summary.html output from cellranger count.)
# --fpr: A value of 0.01 is generally quite good, but you can generate a few output count matrices and compare them by choosing a few values: 0.01 0.05 0.1
# --epochs: 150 is typically a good choice. Look for a reasonably-converged ELBO value in the output PDF learning curve (meaning it looks like it has reached some saturating value). Though it may be tempting to train for more epochs, it is not advisable to over-train, since thisincreases the likelihood of over-fitting. (We regularize to prevent over-fitting, but training for more than 300 epochs is too much.)
# NOTE: total_droplets must be an integer greater than the input expected_cell_count, which is 10000.
