This repository contains scripts for processing MRI data, converting DICOM files to NIfTI format, running FreeSurfer recon-all, and creating BEM models for use with the MNE-Python library. This pipeline is designed to prepare MRI data for source localization of EEG signals.

## Step-by-Step Instructions

1. Convert DICOM to NIfTI

Run the script convert_dicom_to_nifti.zsh to convert DICOM files to NIfTI format.

`sh convert_dicom_to_nifti.zsh`

*convert_dicom_to_nifti.zsh*

```
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
```
