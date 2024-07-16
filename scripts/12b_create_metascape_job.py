# Script to create a metascape job json file
import os
import json

# Define the input and output directories
input_directory = '../results/metascape_input/'
output_file = 'PMI.job'

# Define the base paths for the input and output files
base_input_path = '/data/PMI/metascape_input'
base_output_path = '/data/PMI/metascape_output'

# Open the output file in write mode
with open(output_file, 'w') as job_file:
    # Loop through each file in the input directory
    for filename in os.listdir(input_directory):
        # Skip if it is a directory
        if os.path.isdir(os.path.join(input_directory, filename)):
            continue
        
        # Construct the full input file path
        full_input_path = os.path.join(input_directory, filename)
        
        # Check if the file is empty
        if os.path.getsize(full_input_path) == 0:
            # Comment out the line if the file is empty
            job_file.write(f"# {filename} is empty and has been skipped.\n")
        else:
            # Construct the input and output paths
            input_path = os.path.join(base_input_path, filename)
            output_path = os.path.join(base_output_path, filename.replace('.txt', ''))

            # Create the dictionary for the current file
            job_entry = {
                "input": input_path,
                "source_tax_id": "mouse",
                "output": output_path,
                "single": True
            }

            # Write the JSON line to the job file
            job_file.write(json.dumps(job_entry) + '\n')

print(f"Job file '{output_file}' has been created successfully.")
