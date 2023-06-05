# Read IP addresses from file
with open('text_files/vms.txt', 'r') as file:
    ip_addresses = file.read().splitlines()

# Convert to string array format
ip_array = str(ip_addresses)

# Save in a text file
with open('temp.txt', 'w') as file:
    file.write(ip_array)
