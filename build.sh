#!/bin/bash

command -v python >/dev/null 2>&1 || { echo >&2 "python is required but it's not installed or is not on the PATH. Aborting."; exit 1; }
command -v sass >/dev/null 2>&1 || { echo >&2 "sass is required but it's not installed or is not on the PATH. Aborting."; exit 1; }
command -v closurebuilder.py >/dev/null 2>&1 || { echo >&2 "closurebuilder.py is required but it's not installed or is not on the PATH. Aborting."; exit 1; }

echo "########## Step 1: Create Endpoints libraries ##########"
python lib/endpoints/endpointscfg.py get_client_lib -o . java api-service.ShortLinkApi
python lib/endpoints/endpointscfg.py get_openapi_spec api-service.ShortLinkApi --hostname localhost

echo "########## Step 2: Compile sass to css ##########"
sass style/main.scss > style/main.css

echo "########## Step 3: Compile javascript library ##########"
# Find where the Closure library is installed from the closurebuilder.py binary assuming it's on the path
fullpath=`which closurebuilder.py`
fulldir=`dirname ${fullpath}`
closuredir="${fulldir}/../../.."

closurebuilder.py \
--namespace=lnkr --namespace=lnkr.data --output_mode=compiled \
--compiler_jar=closure-compiler.jar \
--root=${closuredir} \
--root=js/ > js/lnkr-compiled.js

