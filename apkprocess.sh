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
  apk_name=$(basename "$apk_file" ".apk") # Retain apk_name for potential future use or clarity
  
  # Construct the output directory path including the relative path of the APK
  # Remove input_dir prefix: e.g., "input/foo/bar.apk" -> "foo/bar.apk" (if input_dir is "input")
  relative_path=${apk_file#"$input_dir"/}
  # Remove .apk suffix: e.g., "foo/bar.apk" -> "foo/bar"
  relative_path_no_ext=${relative_path%.apk}
  # Prepend output_dir: e.g., "foo/bar" -> "output/foo/bar" (if output_dir is "output")
  apk_output_dir="${output_dir}/${relative_path_no_ext}"
  
  # Create the specific output directory for this APK before extraction
  mkdir -p "${apk_output_dir}"

  # Extract audio and video assets using 7z
  7z x -o"${apk_output_dir}" -ir'!*.mp3' -ir'!*.wav' -ir'!*.ogg' -ir'!*.mp4' -ir'!*.webm' -ir'!*.wmv' -ir'!*.wma'  -ir'!*.m4a'  -ir'!*.flac' -ir'!*.raw' -ir'!*.pcm' -ir'!*.opus'  "$apk_file" -aos	

  # Preserve the directory path in the APK file
  find "${apk_output_dir}" -type d -empty -delete
done

echo "Extraction complete."
