import requests
import xml.etree.ElementTree as ET
import math

with open('vm.txt', 'r') as file:
    vm_names = file.read().splitlines()

with open('ips.txt', 'r') as file:
    ips = file.read().splitlines()

for index, vm_name in enumerate(vm_names):
    url = f"http://{ips[index]}/geoserver/topp/{vm_name}/gwc/service/wmts?REQUEST=GetCapabilities"

    # Fetch the XML data
    response = requests.get(url)
    xml_data = response.text

    # Parse the XML
    root = ET.fromstring(xml_data)

    # Find the LowerCorner and UpperCorner elements
    namespace = {"ows": "http://www.opengis.net/ows/1.1"}
    lower_corner = root.find(".//ows:LowerCorner", namespace).text
    upper_corner = root.find(".//ows:UpperCorner", namespace).text

    # Split the strings and convert values to radians
    lower_corner_values = [math.radians(float(value)) for value in lower_corner.split()]
    upper_corner_values = [math.radians(float(value)) for value in upper_corner.split()]

    # Assign values to individual variables
    lower_x, lower_y = lower_corner_values
    upper_x, upper_y = upper_corner_values

    # Print the assigned values
    print("[" + str(lower_x) + "," + str(lower_y) + ",", str(upper_x) + "," + str(upper_y) + "],")