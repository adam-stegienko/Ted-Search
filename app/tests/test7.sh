#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)
green='\033[0;32m'
no_color='\033[0m'

pushd ../../environment > /dev/null
DYNAMIC_IP=$(terraform output -raw public_ip)
popd > /dev/null

echo " "
echo $0
echo " "

echo "${bold}TEST 7/10 - Jenkins${normal}"
curl -i http://$DYNAMIC_IP/api/search?q=jenkins | tac | tac | head -8

if [[ $(curl -i http://$DYNAMIC_IP/api/search?q=jenkins | tac | tac | head -1 | cut -d " " -f2) == "200" ]]; then
    echo "Passed."
    echo "Passed." >> output.txt
else
    echo "Failed."
    echo "Failed." >> output.txt
fi