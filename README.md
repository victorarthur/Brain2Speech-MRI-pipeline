This repository contains scripts for processing MRI data, converting DICOM files to NIfTI format, running FreeSurfer recon-all, and creating BEM models for use with the MNE-Python library. This pipeline is designed to prepare MRI data for source localization of EEG signals.

Author: **Frigyes Viktor Arthur**, email: *hello@victorarthur.com*

## Step-by-Step Instructions

### 1. Convert DICOM to NIfTI

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
- Input: DICOM files located in /data/MRI/[Subject]/*.dcm
- Output: NIfTI files saved in /data/MRI/nifti_output/[Subject]/*.nii

This script converts MRI data from DICOM format to NIfTI format using the dcm2niix tool, making it compatible with various neuroimaging tools and pipelines.

### 2. Run FreeSurfer Recon-All

Run the script freesurfer_recon.zsh to process the MRI data using FreeSurfer.

`sh freesurfer_recon.zsh`

*freesurfer_recon.zsh*

```
#!/bin/zsh

# Define the directory containing subject data
DATA_DIR="/data/MRI/nifti_output"

# Set the FreeSurfer SUBJECTS_DIR
export SUBJECTS_DIR="/data/MRI/freesurfer_subjects"
mkdir -p "$SUBJECTS_DIR"

# Define the directory where FreeSurfer will save results
SUBJECTS_DIR="$SUBJECTS_DIR"

# Loop through each subject directory in DATA_DIR
for subject_dir in "$DATA_DIR"/*; do
    if [ -d "$subject_dir" ]; then
        subject_name=$(basename "$subject_dir")
        echo "Processing subject: $subject_name"

        # Use T1-weighted MRI for recon-all
        t1_file="$subject_dir"/MPRAGE_gaser_5.nii
        if [ -f "$t1_file" ]; then
            recon-all -s "$subject_name" -i "$t1_file" -all -sd "$SUBJECTS_DIR"
        else
            echo "T1-weighted MRI file not found for $subject_name"
        fi

        # Add additional processing for T2-weighted MRI if needed
        # t2_file="$subject_dir"/t2_spc_sag_p2_iso_HCP_6.nii
        # if [ -f "$t2_file" ]; then
        #     recon-all -s "$subject_name" -i "$t2_file" -all -sd "$SUBJECTS_DIR"
        # fi
    fi
done
```

- Input: NIfTI files located in /data/MRI/nifti_output/[Subject]/*.nii
- Output: FreeSurfer subject directory with various processed files, including mri/T1.mgz and surf/* files, saved in /data/MRI/freesurfer_subjects/[Subject]

This script automates the FreeSurfer recon-all pipeline to generate cortical and subcortical reconstructions from T1-weighted MRI data.

### 3. Create BEM Models

Run the script create_bem_models.zsh to create BEM surfaces using FreeSurfer and MNE-Python.

`sh create_bem_models.zsh`

*create_bem_models.zsh*

```
#!/bin/zsh

# Set the FreeSurfer SUBJECTS_DIR
export SUBJECTS_DIR="/data/MRI/freesurfer_subjects"

# Loop through each subject and create BEM surfaces
for subject in "$SUBJECTS_DIR"/*; do
    if [ -d "$subject" ]; then
        subject_name=$(basename "$subject")
        mkheadsurf -s "$subject_name"
        mne watershed_bem -s "$subject_name" --overwrite
    fi
done
```

- Input: FreeSurfer subject directories located in /data/MRI/freesurfer_subjects/[Subject]
- Output: BEM surfaces saved in /data/MRI/freesurfer_subjects/[Subject]/bem/*

This script generates BEM models necessary for EEG source localization using the MNE-Python library.


## Installation

**FreeSurfer**

Download FreeSurfer:

1. Visit the FreeSurfer download page and download the appropriate version for your system.
2. Install FreeSurfer:
   Follow the installation instructions provided on the FreeSurfer website.
4.	Set Up FreeSurfer:
   Add the following lines to your shell startup file (~/.bashrc or ~/.zshrc):
```
export FREESURFER_HOME=/path/to/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh
export SUBJECTS_DIR=/data/MRI/freesurfer_subjects
```

**MNE-Python**
1.	Install MNE-Python:
   `pip install mne`
3.	Install additional dependencies if necessary:
   `pip install nibabel matplotlib numpy scipy`


