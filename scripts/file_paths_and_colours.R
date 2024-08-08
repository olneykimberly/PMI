#--- libraries
library(Seurat)
library(stringr)
library(ggplot2)
library(gridExtra)
library(grid)
library(lattice)
library(Azimuth)
library(dittoSeq)
library(dplyr)
library(RColorBrewer)
library(DESeq2)
require(openxlsx)
library(ggrepel)
#detach("package:xlsx", unload = TRUE)

#--- variables
PMI_colors <- c("#4682B480",  "#8B7E66")
genotype_colors <- c("#4682B4", "#B4AF46","#B4464B", "gray35")
SexColors <- c("#490092", "#D55E00")
#sample_colors <- c("#C6E8EE","#CAEBEE","#CFEDEE","#CEEAEA", 
#                  "#D8B89D","#D3B499", "#CEB096","#C6A990","#BCA189",
#                  "#C7DEFB","#C4DBF8", "#C1D8F4","#BED4F1","#BCD2EE", 
#                  "wheat", "wheat1", "wheat2", "wheat3", "wheat4",  "#8B7E66")

#--- references and metadata
metadata <-
  read.delim(
    "/research/labs/neurology/fryer/m239830/PMI/metadata.tsv")

pathToRef = c("/research/labs/neurology/fryer/projects/references/mouse/refdata-gex-GRCm39-2024-A")
pathToRawData = c("/research/labs/neurology/fryer/projects/PMI/")
gene_info <- read.delim(paste0(pathToRef, "/star/geneInfo.tab"), header = FALSE)
gene_info = gene_info[-1,]
gene_info <- gene_info %>% 
  rename(
    V1 = "gene_ID",
    V2 = "gene_name", 
    V3 = "type"
  )

# cell cycle 
cell_cycle_markers <- read.delim("/research/labs/neurology/fryer/projects/references/mouse/cell_cycle_mouse.tsv")
m.s.genes <- subset(cell_cycle_markers, phase == "S")
m.g2m.genes <- subset(cell_cycle_markers, phase != "S")

#--- functions 
saveToPDF <- function(...) {
  d = dev.copy(pdf, ...)
  dev.off(d)
}

# Basic function to convert human to mouse gene names
# https://www.r-bloggers.com/2016/10/converting-mouse-to-human-gene-names-with-biomart-package/ 
# convertHumanGeneList <- function(x){
#   require("biomaRt")
#   human = useMart("ensembl", dataset = "hsapiens_gene_ensembl")
#   mouse = useMart("ensembl", dataset = "mmusculus_gene_ensembl")
#   genesV2 = getLDS(attributes = c("hgnc_symbol"), filters = "hgnc_symbol", values = x , mart = human, attributesL = c("mgi_symbol"), martL = mouse, uniqueRows=T)
#   humanx <- unique(genesV2[, 2])
#   # Print the first 6 genes found to the screen
#   print(head(humanx))
#   return(humanx)
# }
