#!/bin/bash

# Read VM names from vm.txt file
vm_names=$(cat vm.txt)

# Read zones from zone.txt file
zones=$(cat zone.txt)

# Iterate over each line in the files
while read -r vm_name && read -r zone; do
    gcloud compute instances describe "$vm_name" --zone="$zone" --format="get(networkInterfaces[0].accessConfigs[0].natIP)"
done <<< "$(paste -d'\n' vm.txt zone.txt)"
