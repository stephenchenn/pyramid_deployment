import requests

username = 'admin'
password = 'geoserver'

# find external ip address
metadata_url = "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip"
headers = {"Metadata-Flavor": "Google"}
response = requests.get(metadata_url, headers=headers)
external_ip = response.text.strip()

# find vm instance name
metadata_url = "http://metadata.google.internal/computeMetadata/v1/instance/name"
headers = {"Metadata-Flavor": "Google"}
response = requests.get(metadata_url, headers=headers)
instance_name = response.text.strip()

# create data store
url = 'http://' + external_ip + '/geoserver/rest/workspaces/topp/coveragestores'
xml_data = '<coverageStore><workspace>topp</workspace><name>' + instance_name + \
    '</name><type>ImagePyramid</type><enabled>true</enabled><url>file:data/' + \
    instance_name + '</url></coverageStore>'
headers = {'Content-type': 'text/xml'}
response = requests.post(url, auth=(
    username, password), headers=headers, data=xml_data)
print(response.text + ' store created.')

# create layer
url = 'http://' + external_ip + \
    '/geoserver/rest/workspaces/topp/coveragestores/' + instance_name + '/coverages'
xml_data = '<coverage><nativeName>' + instance_name + '</nativeName><title>' + \
    instance_name + '</title><name>' + instance_name + \
    '</name><srs>EPSG:4326</srs></coverage>'
headers = {'Content-type': 'text/xml'}
response = requests.post(url, auth=(
    username, password), headers=headers, data=xml_data)
print(response.text + ' layer created.')

print("layer published")