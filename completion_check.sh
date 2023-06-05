#!/bin/bash

# Set the project ID
PROJECT_ID="cgfy-stephan"

# Fetch all VM names
VM_NAMES=$(gcloud compute instances list --project="$PROJECT_ID" --format="value(name)")

# Iterate over each VM name
for VM_NAME in $VM_NAMES; do
  # Fetch the 'startup-script-run' metadata value for each VM
  METADATA_VALUE=$(gcloud compute instances describe "$VM_NAME" --project="$PROJECT_ID" --format="value(metadata.items.startup-script-run)")

  # Print the VM name and metadata value to the file
  echo "VM Name: $VM_NAME" >> completion.txt
  echo "Startup Script Run Metadata: $METADATA_VALUE" >> completion.txt
  echo "-------------------" >> completion.txt
done
