import json

# only geojson file
f = open('geoJsonExtent_zoom_10.json')

# load it as a dictionary
data = json.load(f)

for i in data['features']:
    if "fileNames" in i["properties"]:
        x = i["properties"]["x"]
        y = i["properties"]["y"]
        theZone = str(x) + "-" + str(y)
        with open("zone", "a") as file:
            file.write(theZone + '\n')