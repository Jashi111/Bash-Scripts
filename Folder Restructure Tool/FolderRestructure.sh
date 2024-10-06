#!/bin/bash

# Define the source and destination directories
source_base_dir="/opt/Folder"
destination_dir="/opt/Reorder"

# Get the current year
current_year=$(date +'%Y')

# Iterate over each main folder (01 to 12)
for ((main_folder=1; main_folder<=12; main_folder++)); do
    # Pad the main folder number if necessary
    main_folder_padded=$(printf "%02d" $main_folder)

    # Determine the month based on the main folder number
    case $main_folder_padded in
        01) month="January" ;;
        02) month="February" ;;
        03) month="March" ;;
        04) month="April" ;;
        05) month="May" ;;
        06) month="June" ;;
        07) month="July" ;;
        08) month="August" ;;
        09) month="September" ;;
        10) month="October" ;;
        11) month="November" ;;
        12) month="December" ;;
        *) echo "Invalid month"; exit 1 ;;
    esac

    # Get the list of day folders inside the main folder
    day_folders="${source_base_dir}/${main_folder_padded}/"*

    # Iterate over each day folder
    for day_folder in $day_folders; do
        # Get the day number from the folder name
        day=$(basename "$day_folder")

        # Create the destination directory with year-month-date format
        destination="${destination_dir}/${current_year}-${main_folder_padded}-${day}"

        # Move the day folder to the destination
        cp -r "$day_folder" "$destination"
    done
done
