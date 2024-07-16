setwd("/research/labs/neurology/fryer/m239830/PMI/scripts/")

# Libraris, paths, colors
source(here::here("/research/labs/neurology/fryer/m239830/PMI/scripts", "file_paths_and_colours.R"))
treatment <- "PMI"
color.panel <- dittoColors()
metadata <- subset(metadata, sampleID != "P_60" & sampleID != "B_6")
metadata$sampleID <- factor(metadata$sampleID, levels = c(metadata$sampleID))
samples <- metadata$sampleID 

# read object
dataObject <- readRDS(file = paste0("../rObjects/", treatment, ".dataObject.clean.rds"))
# inspect
dataObject
Layers(dataObject)
# List of cell types to analyze
cell_types <- c(unique(dataObject$individual_clusters))

# only protein coding genes
protein_coding_genes <- subset(gene_info, type == "protein_coding")
counts <- GetAssayData(object = dataObject, layer = "counts")
keep <- rownames(counts) %in% protein_coding_genes$gene_name # false when mt.gene
counts.filtered <- counts[keep,]

# overwrite dataObject.filtered
dataObject.filtered <- CreateSeuratObject(counts.filtered, 
                                          meta.data = dataObject@meta.data)

# print features removed
print(paste0(dim(counts)[1] - dim(counts.filtered)[1], " features removed"))
dataObject <- dataObject.filtered
DefaultAssay(dataObject) <- "RNA"
dataObject <- NormalizeData(dataObject)

# Mast 
## 1) PS19 vs WT
## 2) 3 hours vs Fresh
# Directory to save the results
output_dir <- "../results/DEGs/MAST/"

# Loop through each cell type to perform differential expression analysis for each condition
for (cell_type in cell_types) {
  # Strain comparison
  dataObject$celltype.strain <- paste(dataObject$individual_clusters, dataObject$strain, sep = "_")
  Idents(dataObject) <- "celltype.strain"
  df <- FindMarkers(dataObject, ident.1 = paste(cell_type, "PS19", sep = "_"), ident.2 = paste(cell_type, "WT", sep = "_"), 
                                   test.use = "MAST",  min.pct = 0.1,verbose = FALSE, latent.vars = c("sex", "time"))

  df$percent_difference <- abs(df$pct.1 - df$pct.2) # percent difference 
  colnames(df)[c(3,4)] <- c("percent_PS19","percent_WT") # define the percent columns 
  df$gene <- rownames(df) # set row names as column gene 
  DEGs <- df[,c(7,1,2,5,3,4,6)] # reorder 
  strain_output_path <- file.path(output_dir, paste0(cell_type, "_PS19_vs_WT_comparison.txt"))
  write.table(DEGs, file = strain_output_path, sep = "\t", quote = FALSE, row.names = FALSE)
  rm(df, DEGs)
  
  # Time comparison
  dataObject$celltype.time <- paste(dataObject$individual_clusters, dataObject$time, sep = "_")
  Idents(dataObject) <- "celltype.time"
  df <- FindMarkers(dataObject, ident.1 = paste(cell_type, "3", sep = "_"), ident.2 = paste(cell_type, "0", sep = "_"), 
                    test.use = "MAST",  min.pct = 0.1,verbose = FALSE, latent.vars = c("sex", "strain"))
  # Save the time comparison results to a text file
  df$percent_difference <- abs(df$pct.1 - df$pct.2)
  colnames(df)[c(3,4)] <- c("percent_3","percent_0")
  df$gene <- rownames(df)
  DEGs <- df[,c(7,1,2,5,3,4,6)]
  time_output_path <- file.path(output_dir, paste0(cell_type, "_3_vs_0_hours_comparison.txt"))
  write.table(DEGs, file = time_output_path, sep = "\t", quote = FALSE, row.names = FALSE)
  rm(df, DEGs)
}


# DE 0 hours only: PS19 vs WT
Idents(dataObject) <- dataObject$time
dataObject.0hours <- subset(dataObject, cells = WhichCells(dataObject, idents = setdiff(unique(dataObject$time), c(3))))
Idents(dataObject.0hours) <- dataObject.0hours$individual_clusters # Re-define the idents as the cell type
output_dir <- "../results/DEGs/MAST/"
for (cell_type in cell_types) {
  dataObject.0hours$celltype.strain <- paste(dataObject.0hours$individual_clusters, dataObject.0hours$strain, sep = "_")
  Idents(dataObject.0hours) <- "celltype.strain"
  df <- FindMarkers(dataObject.0hours, ident.1 = paste(cell_type, "PS19", sep = "_"), ident.2 = paste(cell_type, "WT", sep = "_"), 
                    test.use = "MAST",  min.pct = 0.1,verbose = FALSE, latent.vars = c("sex"))
  df$percent_difference <- abs(df$pct.1 - df$pct.2) # percent difference 
  colnames(df)[c(3,4)] <- c("percent_PS19","percent_WT") # define the percent columns 
  df$gene <- rownames(df) # set row names as column gene 
  DEGs <- df[,c(7,1,2,5,3,4,6)] # reorder 
  strain_output_path <- file.path(output_dir, paste0(cell_type, "_PS19_vs_WT_comparison_0hours_only.txt"))
  write.table(DEGs, file = strain_output_path, sep = "\t", quote = FALSE, row.names = FALSE)
  rm(df, DEGs)
}
rm(dataObject.0hours)


# DE 3 hours only: PS19 vs WT
Idents(dataObject) <- dataObject$time
dataObject.3hours <- subset(dataObject, cells = WhichCells(dataObject, idents = setdiff(unique(dataObject$time), c(0))))
Idents(dataObject.3hours) <- dataObject.3hours$individual_clusters # Re-define idents as cell types 
output_dir <- "../results/DEGs/MAST/"
for (cell_type in cell_types) {
  dataObject.3hours$celltype.strain <- paste(dataObject.3hours$individual_clusters, dataObject.3hours$strain, sep = "_")
  Idents(dataObject.3hours) <- "celltype.strain"
  df <- FindMarkers(dataObject.3hours, ident.1 = paste(cell_type, "PS19", sep = "_"), ident.2 = paste(cell_type, "WT", sep = "_"), 
                    test.use = "MAST",  min.pct = 0.1,verbose = FALSE, latent.vars = c("sex"))
  df$percent_difference <- abs(df$pct.1 - df$pct.2) # percent difference 
  colnames(df)[c(3,4)] <- c("percent_PS19","percent_WT") # define the percent columns 
  df$gene <- rownames(df) # set row names as column gene 
  DEGs <- df[,c(7,1,2,5,3,4,6)] # reorder 
  strain_output_path <- file.path(output_dir, paste0(cell_type, "_PS19_vs_WT_comparison_3hours_only.txt"))
  write.table(DEGs, file = strain_output_path, sep = "\t", quote = FALSE, row.names = FALSE)
  rm(df, DEGs)
}
rm(dataObject.3hours)


# DE PS19 only: 3 hours vs Fresh
Idents(dataObject) <- dataObject$strain
dataObject.PS19 <- subset(dataObject, cells = WhichCells(dataObject, idents = setdiff(unique(dataObject$strain), c("WT"))))
Idents(dataObject.PS19) <- dataObject.PS19$individual_clusters 
output_dir <- "../results/DEGs/MAST/"

for (cell_type in cell_types) {
  dataObject.PS19$celltype.time <- paste(dataObject.PS19$individual_clusters, dataObject.PS19$time, sep = "_")
  Idents(dataObject.PS19) <- "celltype.time"
  df <- FindMarkers(dataObject.PS19, ident.1 = paste(cell_type, "3", sep = "_"), ident.2 = paste(cell_type, "0", sep = "_"), 
                    test.use = "MAST",  min.pct = 0.1,verbose = FALSE, latent.vars = c("sex"))
  df$percent_difference <- abs(df$pct.1 - df$pct.2) # percent difference 
  colnames(df)[c(3,4)] <- c("percent_3","percent_0") # define the percent columns 
  df$gene <- rownames(df) # set row names as column gene 
  DEGs <- df[,c(7,1,2,5,3,4,6)] # reorder 
  strain_output_path <- file.path(output_dir, paste0(cell_type, "_3_vs_0_hours_comparison_PS19_only.txt"))
  write.table(DEGs, file = strain_output_path, sep = "\t", quote = FALSE, row.names = FALSE)
  rm(df, DEGs)
}


# DE WT only: 3 hours vs Fresh
Idents(dataObject) <- dataObject$strain
dataObject.WT <- subset(dataObject, cells = WhichCells(dataObject, idents = setdiff(unique(dataObject$strain), c("PS19"))))
Idents(dataObject.WT) <- dataObject.WT$individual_clusters
output_dir <- "../results/DEGs/MAST/"
for (cell_type in cell_types) {
  # Strain comparison
  dataObject.WT$celltype.time <- paste(dataObject.WT$individual_clusters, dataObject.WT$time, sep = "_")
  Idents(dataObject.WT) <- "celltype.time"
  df <- FindMarkers(dataObject.WT, ident.1 = paste(cell_type, "3", sep = "_"), ident.2 = paste(cell_type, "0", sep = "_"), 
                    test.use = "MAST",  min.pct = 0.1,verbose = FALSE, latent.vars = c("sex"))
  df$percent_difference <- abs(df$pct.1 - df$pct.2) # percent difference 
  colnames(df)[c(3,4)] <- c("percent_3","percent_0") # define the percent columns 
  df$gene <- rownames(df) # set row names as column gene 
  DEGs <- df[,c(7,1,2,5,3,4,6)] # reorder 
  output_path <- file.path(output_dir, paste0(cell_type, "_3_vs_0_hours_comparison_WT_only.txt"))
  write.table(DEGs, file = output_path, sep = "\t", quote = FALSE, row.names = FALSE)
  rm(df, DEGs, output_path)
}
rm(dataObject.WT, output_dir)


# DE XX female only: 3 hours vs Fresh
Idents(dataObject) <- dataObject$sex
dataObject.female <- subset(dataObject, cells = WhichCells(dataObject, idents = setdiff(unique(dataObject$sex), c("Male"))))
Idents(dataObject.female) <- dataObject.female$individual_clusters
output_dir <- "../results/DEGs/MAST/"
for (cell_type in cell_types) {
  dataObject.female$celltype.time <- paste(dataObject.female$individual_clusters, dataObject.female$time, sep = "_")
  Idents(dataObject.female) <- "celltype.time"
  df <- FindMarkers(dataObject.female, ident.1 = paste(cell_type, "3", sep = "_"), ident.2 = paste(cell_type, "0", sep = "_"), 
                    test.use = "MAST",  min.pct = 0.1,verbose = FALSE, latent.vars = c("strain"))
  df$percent_difference <- abs(df$pct.1 - df$pct.2) # percent difference 
  colnames(df)[c(3,4)] <- c("percent_3","percent_0") # define the percent columns 
  df$gene <- rownames(df) # set row names as column gene 
  DEGs <- df[,c(7,1,2,5,3,4,6)] # reorder 
  output_path <- file.path(output_dir, paste0(cell_type, "_3_vs_0_hours_comparison_XX_female_only.txt"))
  write.table(DEGs, file = output_path, sep = "\t", quote = FALSE, row.names = FALSE)
  rm(df, DEGs, output_path)
}
rm(dataObject.female, output_dir)


# DE XY male only: 3 hours vs Fresh
Idents(dataObject) <- dataObject$sex
dataObject.male <- subset(dataObject, cells = WhichCells(dataObject, idents = setdiff(unique(dataObject$sex), c("Female"))))
Idents(dataObject.male) <- dataObject.male$individual_clusters
output_dir <- "../results/DEGs/MAST/"
for (cell_type in cell_types) {
  dataObject.male$celltype.time <- paste(dataObject.male$individual_clusters, dataObject.male$time, sep = "_")
  Idents(dataObject.male) <- "celltype.time"
  df <- FindMarkers(dataObject.male, ident.1 = paste(cell_type, "3", sep = "_"), ident.2 = paste(cell_type, "0", sep = "_"), 
                    test.use = "MAST",  min.pct = 0.1,verbose = FALSE, latent.vars = c("strain"))
  df$percent_difference <- abs(df$pct.1 - df$pct.2) # percent difference 
  colnames(df)[c(3,4)] <- c("percent_3","percent_0") # define the percent columns 
  df$gene <- rownames(df) # set row names as column gene 
  DEGs <- df[,c(7,1,2,5,3,4,6)] # reorder 
  output_path <- file.path(output_dir, paste0(cell_type, "_3_vs_0_hours_comparison_XY_male_only.txt"))
  write.table(DEGs, file = output_path, sep = "\t", quote = FALSE, row.names = FALSE)
  rm(df, DEGs, output_path)
}
rm(dataObject.male, output_dir)




