#!/bin/bash

while true; do
    output=$(tail -n 1 output.txt)

    if echo "$output" | grep -q "^mergedPyramid/1/"; then
        rm -r tas_images
        break
    fi
    sleep 300  # Sleep for 5 minutes (300 seconds)
done