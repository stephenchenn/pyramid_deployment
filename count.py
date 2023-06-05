import json

# only geojson file
f = open('geoJsonExtent_zoom_10.json')

# load it as a dictionary
data = json.load(f)

below_a_hundred = 0
below_a_hundred_list = []

below_a_thousand = 0
below_a_thousand_list = []

a_thousand_to_two = 0
a_thousand_to_two_list = []

two_thousand_to_three = 0
two_thousand_to_three_list = []

for index, i in enumerate(data['features']):
    if "fileNames" in i["properties"]:
        count = len(i["properties"]["fileNames"])

        x = i["properties"]["x"]
        y = i["properties"]["y"]
        theZone = str(x) + "-" + str(y)

        if count <= 100:
            below_a_hundred += 1
            below_a_hundred_list.append(str(i["properties"]["x"]) + '-' + str(i["properties"]["y"]))

            with open("zones/tiny_zones", "a") as file:
                file.write(theZone + '\n')

        elif count > 100 and count <= 1000:
            below_a_thousand += 1
            below_a_thousand_list.append(str(i["properties"]["x"]) + '-' + str(i["properties"]["y"]))

            with open("zones/small_zones", "a") as file:
                file.write(theZone + '\n')
            
        elif count > 1000 and count < 2000:
            a_thousand_to_two += 1
            a_thousand_to_two_list.append(str(i["properties"]["x"]) + '-' + str(i["properties"]["y"]))

            with open("zones/medium_zones", "a") as file:
                file.write(theZone + '\n')

        else:
            two_thousand_to_three += 1
            two_thousand_to_three_list.append(str(i["properties"]["x"]) + '-' + str(i["properties"]["y"]))

            with open("zones/large_zones", "a") as file:
                file.write(theZone + '\n')

print(below_a_hundred_list)
print(below_a_hundred)
print(below_a_thousand_list)
print(below_a_thousand)
print(a_thousand_to_two_list)
print(a_thousand_to_two)
print(two_thousand_to_three_list)
print(two_thousand_to_three)

print(sum([below_a_hundred, below_a_thousand, a_thousand_to_two, two_thousand_to_three]))