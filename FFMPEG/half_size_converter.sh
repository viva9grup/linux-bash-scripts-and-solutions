#!/bin/bash

source_dir=$(pwd)

destination_dir="$source_dir/output"
mkdir -p "$destination_dir"

jpg_quality=2

for file in "$source_dir"/*.{jpg,png}; do
    filename=$(basename -- "$file")
    extension="${filename##*.}"
    filename="${filename%.*}"

    dimensions=$(identify -format "%wx%h" "$file")
    IFS='x' read -r original_width original_height <<< "$dimensions"
    new_width=$((original_width / 2))
    new_height=$((original_height / 2))
    
    if [ "$extension" = "jpg" ]; then
        ffmpeg -i "$file" -vf "scale=$new_width:$new_height" -q:v "$jpg_quality" "$destination_dir/$filename.jpg"
    elif [ "$extension" = "png" ]; then
        convert "$file" -resize "${new_width}x${new_height}" -quality "$jpg_quality" "$destination_dir/$filename.jpg"
    else
        echo "Unsupported file format: $file"
    fi
done

echo "Conversion complete."