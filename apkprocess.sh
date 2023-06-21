#!/bin/bash

# Check if the required arguments are provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <input_directory> <output_directory>"
  exit 1
fi

input_dir="$1"
output_dir="$2"

# Check if the input directory exists
if [ ! -d "$input_dir" ]; then
  echo "Error: Input directory not found."
  exit 1
fi

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Recursively scan for APK files and extract audio and video assets
find "$input_dir" -type f -iname "*.apk" | while read -r apk_file; do
  # Generate a unique subdirectory for each APK's assets
  apk_name=$(basename "$apk_file" ".apk")
  apk_output_dir="${output_dir}/${apk_name}"
  
  # Extract audio and video assets using 7z
  7z x -o"${apk_output_dir}" -ir'!*.mp3' -ir'!*.wav' -ir'!*.ogg' -ir'!*.mp4' -ir'!*.webm' -ir'!*.wmv' -ir'!*.wma'  -ir'!*.m4a'  -ir'!*.flac' -ir'!*.raw' -ir'!*.pcm' -ir'!*.opus'  "$apk_file" -aos	

  # Preserve the directory path in the APK file
  find "${apk_output_dir}" -type d -empty -delete
done

echo "Extraction complete."
