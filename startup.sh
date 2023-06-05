#!/bin/bash

# Check if the startup-script-run metadata is set to true
run_startup_script=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/startup-script-run")

if [[ "$run_startup_script" == "true" ]]; then
    # Your desired commands or actions here
    echo "Running startup script for initial VM creation..."

    sudo su stephen_chen bash -c '
    cd /home/stephen_chen/pyramid_deployment
    vm_name=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/name")
    x=$(echo "$vm_name" | cut -d "-" -f 2)
    y=$(echo "$vm_name" | cut -d "-" -f 3)
    setsid nohup ./run.sh "$x" "$y" > output.txt 2>&1 &
    chmod +x rm.sh
    setsid nohup ./rm.sh > rm.txt 2>&1 &
    '
else
    echo "Startup script already executed. Skipping..."
fi
