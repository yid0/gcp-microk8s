import json
import sys

with open('inventory.json') as f:
    data = json.load(f)

inventory = {
    'all': {
        'hosts': []
    }
}

for vm, ip in data["instance_ips"].items():
    inventory['all']['hosts'].append(ip)

print(json.dumps(inventory))
