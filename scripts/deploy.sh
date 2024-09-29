#!/bin/bash

terraform output -json > ../ansible/inventory.json

exit 0;