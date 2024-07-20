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
