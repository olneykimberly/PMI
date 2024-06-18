# List of sample IDs
sample_list <- c("P_52", "P_54", "B_9", "J_2", "J_1", "P_64", "P_60", "B_8", "B_7", 
                 "P_53", "J_3", "P_65", "P_68", "P_67", "J_4", "B_6", "B_10", "P_62", 
                 "P_69", "P_71")

# Initialize a data frame to store the results
results <- data.frame(SampleID = character(), RawReads = numeric(), stringsAsFactors = FALSE)

# Loop through each sample ID
for (sample_id in sample_list) {
  # Construct the file path
  file_path <- paste0("/research/labs/neurology/fryer/m239830/PMI/cellranger/", sample_id, "/outs/metrics_summary.csv")
  
  # Read the CSV file
  data <- read.csv(file_path)
  
  # Extract the number of raw reads, removing commas and converting to numeric
  raw_reads <- as.numeric(gsub(",", "", data$Number.of.Reads))
  
  # Append the results to the data frame
  results <- rbind(results, data.frame(SampleID = sample_id, RawReads = raw_reads, stringsAsFactors = FALSE))
}

# Print the results
print(results)

# Optionally, save the results to a CSV file
write.csv(results, "raw_reads_summary.csv", row.names = FALSE)

getwd()
