#--- libraries
library(Seurat)

#--- variables
PMI_colors <- c("#4682B480",  "#8B7E66")
genotype_colors <- c("#4682B4", "#B4AF46","#B4464B", "gray35")
SexColors <- c("#490092", "#D55E00")
sample_colors <- c("#C6E8EE","#CAEBEE","#CFEDEE","#CEEAEA", 
                  "#D8B89D","#D3B499", "#CEB096","#C6A990","#BCA189",
                  "#C7DEFB","#C4DBF8", "#C1D8F4","#BED4F1","#BCD2EE", 
                  "wheat", "wheat1", "wheat2", "wheat3", "wheat4",  "#8B7E66")

#--- references and metadata
metadata <-
  read.delim(
    "/research/labs/neurology/fryer/m239830/LBD_CWOW/bulkRNA/results/metadaata_brain_resubmission.txt")

pathToRef = c("/research/labs/neurology/fryer/projects/references/mouse/refdata-gex-GRCm39-2024-A")
pathToRawData = c("/research/labs/neurology/fryer/projects/LBD_CWOW/")

#--- functions 
saveToPDF <- function(...) {
  d = dev.copy(pdf, ...)
  dev.off(d)
}

