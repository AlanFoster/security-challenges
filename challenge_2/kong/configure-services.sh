#!/bin/bash
set -eo pipefail

# Configure services/routes
curl -v -i -X POST http://kong:8001/services --data name=my_service --data url='http://webservice:8000'
curl -v -i -X POST http://kong:8001/services/my_service/routes --data 'paths[]=/' --data name=my_service_main

# TODO: Use a more secure ssh password for the website, currently it's root:admin
# curl -u root:admin http://website/health 2>/dev/null
