#!/bin/bash

source_dir=$(pwd)

destination_dir="$source_dir/output"
mkdir -p "$destination_dir"

jpg_quality=2 # Higher the number means lower quality
render_size=3 # Divide the size by it. 2 means Half the size

for file in "$source_dir"/*.{jpg,png}; do
    filename=$(basename -- "$file")
    extension="${filename##*.}"
    filename="${filename%.*}"

    dimensions=$(identify -format "%wx%h" "$file")
    IFS='x' read -r original_width original_height <<< "$dimensions"

    new_width=$((original_width / render_size))
    new_height=$((original_height / render_size))

    ffmpeg -y -i "$file" -vf "scale=$new_width:$new_height" -q:v "$jpg_quality" "$destination_dir/$filename.$extension"
done

echo "Conversion complete."