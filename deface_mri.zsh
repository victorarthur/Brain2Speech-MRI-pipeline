#!/bin/zsh

# Loop through each subject directory within nifti_output
for subject in /data/MRI/nifti_output/*; do
    if [ -d "$subject" ]; then
        for nifti_file in "$subject"/*.nii; do
            if [ -f "$nifti_file" ]; then
                pydeface "$nifti_file" --outfile "$nifti_file"
            fi
        done
    fi
done
