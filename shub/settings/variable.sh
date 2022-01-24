#!/bin/bash
## script to change domain value in .py scripts
# change value of DOMAIN
DOMAIN=""

# DO NOT TOUCH!
for f in $(find ./ -name '*.py'); do sed -i 's|MY_DOMAIN_NAME = [a-zA-Z0-9.\"-]*|MY_DOMAIN_NAME = '"\"$DOMAIN\""'|g' $f; done
