#!/bin/zsh

# Create the nifti_output directory if it doesn't exist
output_dir="/data/MRI/nifti_output"
mkdir -p "$output_dir"

# Loop through each subject directory within /data/MRI/
for subject in /data/MRI/*; do
    if [ -d "$subject" ] && [ "$(basename "$subject")" != "nifti_output" ]; then
        subject_name=$(basename "$subject")
        subject_output_dir="$output_dir/$subject_name"
        mkdir -p "$subject_output_dir"
        for dicom_file in "$subject"/*.dcm; do
            if [ -f "$dicom_file" ]; then
                dcm2niix -o "$subject_output_dir" -f %p_%s "$dicom_file"
            fi
        done
    fi
done
