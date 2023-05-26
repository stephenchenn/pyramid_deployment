#!/bin/bash

# Check if the script was called with an argument
if [ $# -ne 2 ]; then
  echo "Usage: $0 <x tile index> <y tile index>"
  exit 1
fi

# Store the argument in a variable
x_tile_index="$1"
y_tile_index="$2"

# Fetch tasmania aerial images from google cloud bucket
python3 fetchByZone.py $x_tile_index $y_tile_index
echo "successfully fetched images from tile ($x_tile_index,$y_tile_index) in geographic mercator at zoom level 9"

start_time=$(date +%s)

# Run gdalbuildvrt to create the merged.vrt file
mkdir tas_vrts
gdalbuildvrt tas_vrts/merged.vrt tas_images/*.png
echo "successfully built merge.vrt"

# Run gdal_edit.py with the extracted values
gdal_edit.py -a_srs EPSG:28355 tas_vrts/merged.vrt
# gdalwarp -s_srs EPSG:28355 -t_srs EPSG:4326 tas_vrts/merged.vrt tas_vrts/output.vrt
echo "successfully added the corner coordinates to merge.vrt"

# Prepare an output folder for the pyramid
mkdir mergedPyramid
echo "successfully created target directory mergedPyramid"

# levels=$(python3 find_lvl.py)
# echo "number of levels: $levels"

# Create tile pyramids of the VRT
# -co "COMPRESS=LZW"
# gdal_retile.py -v -r cubic -levels $levels -ps 2048 2048 -co "TILED=YES" -targetDir mergedPyramid tas_vrts/output.vrt
gdal_retile.py -v -r cubic -levels 4 -ps 2048 2048 -co "TILED=YES" -co "COMPRESS=LZW" -targetDir mergedPyramid tas_vrts/merged.vrt
echo "successfully created tile pyramids for merged.vrt"

# run post processing script
chmod +x post_processing_script.sh
./post_processing_script.sh
echo "post processing completed"

# Set the startup-script-run metadata to false
instance_name=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/name")
instance_name=$(basename "$instance_name")
instance_zone=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/zone")
instance_zone=$(basename "$instance_zone")
gcloud compute instances add-metadata projects/cgfy-stephan/zones/"$instance_zone"/instances/"$instance_name" --metadata startup-script-run=false

echo "done"

end_time=$(date +%s)
echo "Elapsed time: $((end_time - start_time)) seconds"
