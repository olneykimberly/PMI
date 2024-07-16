DESeq_cov <- read.delim("/research/labs/neurology/fryer/m239830/PMI/results/DEGs/DESeq2_pseudobulk/microglia_PS19_vs_WT_comparison_pseudo_bulk_with_covariates.txt")
MAST <- read.delim("/research/labs/neurology/fryer/m239830/PMI/results/DEGs/MAST/microglia_PS19_vs_WT_comparison.txt")

DESeq_cov_3_hour <- read.delim("/research/labs/neurology/fryer/m239830/PMI/results/DEGs/DESeq2_pseudobulk/microglia_PS19_vs_WT_comparison_3_hours_only.txt")
MAST_3_hour <- read.delim("/research/labs/neurology/fryer/m239830/PMI/results/DEGs/MAST/microglia_PS19_vs_WT_comparison_3hours_only.txt")

DESeq_cov_0_hour <- read.delim("/research/labs/neurology/fryer/m239830/PMI/results/DEGs/DESeq2_pseudobulk/microglia_PS19_vs_WT_comparison_0_hours_only.txt")
MAST_0_hour <- read.delim("/research/labs/neurology/fryer/m239830/PMI/results/DEGs/MAST/microglia_PS19_vs_WT_comparison_0hours_only.txt")


# All samples MAST vs DESeq
df <- merge(DESeq_cov, MAST, by = "gene")
df <- na.omit(df)
# Calculate the correlation
correlation <- cor(df$log2FoldChange, df$avg_log2FC)

# 3 hours MAST vs DESeq
df <- merge(DESeq_cov_3_hour, MAST_3_hour, by = "gene")
df <- na.omit(df)
# Calculate the correlation
correlation <- cor(df$log2FoldChange, df$avg_log2FC)
ggplot(df, aes(x = log2FoldChange, y = avg_log2FC)) +
  geom_point() +
  ggtitle("Plot of avg_log2FC.x vs log2FoldChange") +
  annotate("text", x = Inf, y = Inf, label = paste("Correlation:", round(correlation, 2)), hjust = 1.1, vjust = 1.1)

# 0 hours MAST vs DESeq
df <- merge(DESeq_cov_0_hour, MAST_0_hour, by = "gene")
df <- na.omit(df)
# Calculate the correlation
correlation <- cor(df$log2FoldChange, df$avg_log2FC)


# 0 hours vs 3 hours within MAST
df <- merge(MAST_3_hour, MAST_0_hour, by = "gene")
df <- na.omit(df)
# Calculate the correlation
correlation <- cor(df$avg_log2FC.x, df$avg_log2FC.y)
ggplot(df, aes(x = avg_log2FC.x, y = avg_log2FC.y)) +
  geom_point() +
  ggtitle("Plot of avg_log2FC.x vs log2FoldChange") +
  annotate("text", x = Inf, y = Inf, label = paste("Correlation:", round(correlation, 2)), hjust = 1.1, vjust = 1.1)


# 0 hours vs 3 hours within DESeq
df <- merge(DESeq_cov_3_hour, DESeq_cov_0_hour, by = "gene")
df <- na.omit(df)
# Calculate the correlation
correlation <- cor(df$log2FoldChange.x, df$log2FoldChange.y)
ggplot(df, aes(x = log2FoldChange.x, y = log2FoldChange.y)) +
  geom_point() +
  ggtitle("Plot of avg_log2FC.x vs log2FoldChange") +
  annotate("text", x = Inf, y = Inf, label = paste("Correlation:", round(correlation, 2)), hjust = 1.1, vjust = 1.1)


df <- merge(DESeq_cov, DESeq_cov_3_hour, by = "gene")
df <- na.omit(df)
# Calculate the correlation
correlation <- cor(df$log2FoldChange.x, df$log2FoldChange.y)
ggplot(df, aes(x = log2FoldChange.x, y = log2FoldChange.y)) +
  geom_point() +
  ggtitle("Plot of avg_log2FC.x vs log2FoldChange") +
  annotate("text", x = Inf, y = Inf, label = paste("Correlation:", round(correlation, 2)), hjust = 1.1, vjust = 1.1)




MAST_female <- read.delim("/research/labs/neurology/fryer/m239830/PMI/results/DEGs/MAST/neuron_3_vs_0_hours_comparison_XX_female_only.txt")
MAST_male <- read.delim("/research/labs/neurology/fryer/m239830/PMI/results/DEGs/MAST/neuron_3_vs_0_hours_comparison_XY_male_only.txt")
DESeq_female <- read.delim("/research/labs/neurology/fryer/m239830/PMI/results/DEGs/DESeq2_pseudobulk/neuron_3_vs_0_hours_comparison_XX_female_only.txt")
DESeq_male <- read.delim("/research/labs/neurology/fryer/m239830/PMI/results/DEGs/DESeq2_pseudobulk/neuron_3_vs_0_hours_comparison_XY_male_only.txt")

# Female vs male within MAST
df <- merge(MAST_female, MAST_male, by = "gene")
df <- na.omit(df)
# Calculate the correlation
correlation <- cor(df$avg_log2FC.x, df$avg_log2FC.y)
ggplot(df, aes(x = avg_log2FC.x, y = avg_log2FC.y)) +
  geom_point() +
  ggtitle("Plot of avg_log2FC.x vs log2FoldChange") +
  annotate("text", x = Inf, y = Inf, label = paste("Correlation:", round(correlation, 2)), hjust = 1.1, vjust = 1.1)


# Female MAST vs DESeq2 
df <- merge(MAST_female, DESeq_female, by = "gene")
df <- na.omit(df)
# Calculate the correlation
correlation <- cor(df$avg_log2FC, df$log2FoldChange)
ggplot(df, aes(x = avg_log2FC, y = log2FoldChange)) +
  geom_point() +
  ggtitle("Plot of avg_log2FC.x vs log2FoldChange") +
  annotate("text", x = Inf, y = Inf, label = paste("Correlation:", round(correlation, 2)), hjust = 1.1, vjust = 1.1)


# Female MAST vs DESeq2 
df <- merge(DESeq_male, DESeq_female, by = "gene")
df <- na.omit(df)
# Calculate the correlation
correlation <- cor(df$log2FoldChange.x, df$log2FoldChange.y)
ggplot(df, aes(x = avg_log2FC, y = log2FoldChange)) +
  geom_point() +
  ggtitle("Plot of avg_log2FC.x vs log2FoldChange") +
  annotate("text", x = Inf, y = Inf, label = paste("Correlation:", round(correlation, 2)), hjust = 1.1, vjust = 1.1)



#--------------------------------
# Plot the data
ggplot(df, aes(x = avg_log2FC, y = log2FoldChange)) +
  geom_point() +
  ggtitle("Plot of avg_log2FC.x vs log2FoldChange") +
  annotate("text", x = Inf, y = Inf, label = paste("Correlation:", round(correlation, 2)), hjust = 1.1, vjust = 1.1)


df <- merge(DESeq_cov, DESeq_cov_0_hour, by = "gene")
df <- na.omit(df)
# Calculate the correlation
correlation <- cor(df$log2FoldChange.x, df$log2FoldChange.y)

# Plot the data
ggplot(df, aes(x = log2FoldChange.x, y = log2FoldChange.y)) +
  geom_point() +
  ggtitle("Plot of avg_log2FC.x vs log2FoldChange") +
  annotate("text", x = Inf, y = Inf, label = paste("Correlation:", round(correlation, 2)), hjust = 1.1, vjust = 1.1)


df <- merge(DESeq_cov_3_hour, DESeq_cov_0_hour, by = "gene")
df <- na.omit(df)
# Calculate the correlation
correlation <- cor(df$log2FoldChange.x, df$log2FoldChange.y)

# Plot the data
ggplot(df, aes(x = log2FoldChange.x, y = log2FoldChange.y)) +
  geom_point() +
  ggtitle("Plot of avg_log2FC.x vs log2FoldChange") +
  annotate("text", x = Inf, y = Inf, label = paste("Correlation:", round(correlation, 2)), hjust = 1.1, vjust = 1.1)




# MAST vs DESeq_covariates
df <- merge(DESeq_cov, MAST, by = "gene")
# Calculate the correlation
correlation <- cor(df$log2FoldChange, df$avg_log2FC)

# Plot the data
ggplot(df, aes(x = log2FoldChange, y = avg_log2FC)) +
  geom_point() +
  ggtitle("Plot of avg_log2FC.x vs log2FoldChange") +
  annotate("text", x = Inf, y = Inf, label = paste("Correlation:", round(correlation, 2)), hjust = 1.1, vjust = 1.1)
rm(df, correlation)


# MAST vs DESeq
df <- merge(DESeq, MAST, by = "gene")
# Calculate the correlation
correlation <- cor(df$avg_log2FC.x, df$avg_log2FC.y)

# Plot the data
ggplot(df, aes(x = avg_log2FC.x, y = avg_log2FC.y)) +
  geom_point() +
  ggtitle("Plot of avg_log2FC.x vs log2FoldChange") +
  annotate("text", x = Inf, y = Inf, label = paste("Correlation:", round(correlation, 2)), hjust = 1.1, vjust = 1.1)
rm(df, correlation)



# Ensure metadata includes time and ident information
dataObject.female$cell_type_time <- paste(dataObject.female$individual_clusters, dataObject.female$time, sep = "_")

# Create a color vector to distinguish between time points
time_colors <- c("0_hour" = "blue", "3_hour" = "red")


# Generate violin plot
VlnPlot(dataObject.female,
        features = c("Xist", "Tsix", "Ctsb"),
        split.by = "time",
        split.plot = TRUE,
        cols = time_colors,
        stack = TRUE, 
        flip = TRUE, 
        assay = "SCT")

VlnPlot(dataObject,
        features = cluster1$gene[1:10],
        cols = color.panel,
        stack = TRUE,
        flip = TRUE,
        split.by = "seurat_clusters")


