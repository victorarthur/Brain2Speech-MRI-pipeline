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
