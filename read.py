with open('ips.txt', 'r') as file:
    vm_names = file.read().splitlines()

print(vm_names)