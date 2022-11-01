#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

echo "${bold}------------------------------------ REMOVE DOCKER RESOURCES --------------------------------------${normal}"
docker-compose down
docker rmi embedash:1.1-SNAPSHOT
echo "${bold}---------------------------------------- BUILD TED SEARCH -----------------------------------------${normal}"
mvn clean verify
echo "${bold}------------------------------------ RUN DOCKERIZED APPLICATION -----------------------------------${normal}"
docker-compose up --detach
echo "${bold}------------------------------------------ E2E TESTING --------------------------------------------${normal}"
echo "${bold}Server booting...${normal}"
sleep 5
./e2e_tests.sh
