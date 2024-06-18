library(patchwork)

P_68 <- CreateSeuratObject(Read10X_h5("/research/labs/neurology/fryer/m239830/PMI/cellranger/P_68/outs/filtered_feature_bc_matrix.h5"))
P_68<- NormalizeData(P_68)
P_68_sex_linked <- VlnPlot(P_68,features = c( "Xist", "Uty", "Ddx3y","Ctsb"),ncol = 5, pt.size = 0)
P_68_sex_linked + plot_annotation(title = "P_68")

path <- paste0("/research/labs/neurology/fryer/m239830/PMI/results/sex_check/P_68_violin")
saveToPDF(paste0(path, ".pdf"), width = 10, height = 3)


library(Seurat)
library(ggplot2)
library(patchwork)

# List of sample IDs
sample_ids <- c("P_52", "P_54", "B_9", "J_2", "J_1", "P_64", "P_60", "B_8", "B_7", "P_53", 
                "J_3", "P_65", "P_68", "P_67", "J_4", "B_6", "B_10", "P_62", "P_69", "P_71")

# Base path for reading data and saving plots
base_path <- "/research/labs/neurology/fryer/m239830/PMI/"

for (sample_id in sample_ids) {
  # Create Seurat object
  data_path <- paste0(base_path, "cellranger/", sample_id, "/outs/filtered_feature_bc_matrix.h5")
  seurat_obj <- CreateSeuratObject(Read10X_h5(data_path))
  
  # Normalize data
  seurat_obj <- NormalizeData(seurat_obj)
  
  # Generate violin plot
  sex_linked_plot <- VlnPlot(seurat_obj, features = c("Xist", "Uty", "Ddx3y", "Ctsb"), ncol = 4, pt.size = 0) +
    plot_annotation(title = sample_id)
  
  # Save plot as PDF
  output_path <- paste0(base_path, "results/sex_check/", sample_id, "_violin.pdf")
  pdf(output_path, width = 7.5, height = 3.5)
  print(sex_linked_plot)
  dev.off()
}
