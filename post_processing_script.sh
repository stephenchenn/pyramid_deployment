#!/bin/bash

# starting geoserver
docker_ps_output=$(sudo docker ps -a)
container_id=$(echo "$docker_ps_output" | awk '{print $1}' | tail -n +2)
sudo docker start "$container_id"

# moving the pyramid to the data directory
cd /home/stephen_chen/pyramid_deployment/mergedPyramid
mkdir 0
find . -maxdepth 1 -type f -name "*.tif" -print0 | xargs -0 mv -t ./0
cd ..
vm_name=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/name")
mv mergedPyramid "$vm_name"
sudo mv "$vm_name" /var/lib/docker/volumes/data_dir/_data

# enabling CORS for Cesium
curl -O "https://storage.googleapis.com/geoserver-web-xml/web.xml"
docker_ps_output=$(sudo docker ps -a)
container_id=$(echo "$docker_ps_output" | awk '{print $1}' | tail -n +2)
sudo docker cp web.xml $container_id:/opt/apache-tomcat-9.0.68/webapps/geoserver/WEB-INF
sudo docker restart $container_id