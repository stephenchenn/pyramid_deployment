#!/bin/bash

while true; do
    output=$(tail -n 1 output.txt)
    delimiter="/"

    IFS="$delimiter" read -ra parts <<< "$output"

    if [[ "${parts[1]}" == "1" ]]; then
        echo "Second part is equal to '1'"
        # rm -r tas_images
        echo "$output"
    fi
    sleep 30  # Sleep for 5 minutes (300 seconds)
done