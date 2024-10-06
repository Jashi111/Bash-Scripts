#!/bin/bash

# Get the first argument passed to the script
input_value=$1

# Define the JSON file paths (make sure to set the correct paths)
JSON_FILE1="/var/www/html/IVR/HUTCH_V5/Prepaid/functions.config.json"
JSON_FILE2="/var/www/html/IVR/HUTCH_V5/Prepaid/functions.map.json"

# Assign values
SP_MSG_Incident_1_Sin="OLResult_Sin.wav"
SP_MSG_Incident_1_Tam="OLResult_Tam.wav"
SP_MSG_Incident_1_Eng="OLResult_eng.wav"

SP_MSG_Incident_2_Sin="Hello World"
SP_MSG_Incident_2_Tam="Hello World"
SP_MSG_Incident_2_Eng="Hello World"

# Check if the argument is provided

if [ -z "$input_value" ]; then
  echo "No input provided. Please provide an argument"
  exit 1
fi

# Define your functions

function SpMsg_1() {
  echo "Executing Function SP_MSG1"
  
  # Use sed to update the three parameters in the JSON_FILE1
  sed -i '
      /"SP_MSG_Update"/,/}/ {
          s/"playFileSinhala": *"[^"]*"/"playFileSinhala": "'"$SP_MSG_Incident_1_Sin"'"/
          s/"playFileEnglish": *"[^"]*"/"playFileEnglish": "'"$SP_MSG_Incident_1_Eng"'"/
          s/"playFileTamil": *"[^"]*"/"playFileTamil": "'"$SP_MSG_Incident_1_Tam"'"/
      }
  ' "$JSON_FILE1"
  
  # Update the mapping file (JSON_FILE2)
  sed -i 's/"SP_MSG_749_none":"MoreInfo_Star"/"SP_MSG_749_none":"SP_MSG_Update"/' "$JSON_FILE2"
}

function SpMsg_2() {
    echo "Executing Function SP_MSG2"

    # Use sed to update the three parameters in the JSON_FILE1
    sed -i '
        /"SP_MSG_Update"/,/}/ {
            s/"playFileSinhala": *"[^"]*"/"playFileSinhala": "'"$SP_MSG_Incident_2_Sin"'"/
            s/"playFileEnglish": *"[^"]*"/"playFileEnglish": "'"$SP_MSG_Incident_2_Eng"'"/
            s/"playFileTamil": *"[^"]*"/"playFileTamil": "'"$SP_MSG_Incident_2_Tam"'"/
        }
    ' "$JSON_FILE1"
}

function BackToNormal() {
  echo "Reverting back to original state"
  
  # Revert the mapping file (JSON_FILE2)
  sed -i 's/"SP_MSG_749_none":"SP_MSG_Update"/"SP_MSG_749_none":"MoreInfo_Star"/' "$JSON_FILE2"
}

# Use a case statement to handle different input values

case "$input_value" in
  "SP_MSG1")
    echo "Executing SP_MSG1 updates"
    SpMsg_1
    ;;
  "SP_MSG2")
    echo "Executing SP_MSG2 updates"
    SpMsg_2
    ;;
  "Original")
    echo "Reverting to Original state"
    BackToNormal
    ;;
  *)
    echo "Invalid input provided."
    ;;
esac
