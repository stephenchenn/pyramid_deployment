#!/bin/bash

while true; do
    # Get the last line from the file
    last_line=$(tail -n 1 output.txt)

    # Check if the last line starts with any of the specified patterns
    if [[ $last_line =~ ^(mergedPyramid\/[1-4]\/) ]]; then
        echo "Matching pattern found: $last_line"
        break
    fi

    sleep 300  # Sleep for 5 minutes (300 seconds)
done