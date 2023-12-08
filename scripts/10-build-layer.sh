#!/bin/bash
set -eo pipefail
rm -rf ../package
cd ../file-metadata
pip3 install --target ../package/python -r requirements.txt