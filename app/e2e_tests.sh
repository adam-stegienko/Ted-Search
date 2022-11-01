#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)
green='\e[1;32m'
red='\e[1;31m'
no_color='\033[0m'

pushd ./tests > /dev/null
    command rm -f output.txt
    command ./test1.sh
    command ./test2.sh
    command ./test3.sh
    command ./test4.sh
    command ./test5.sh
    command ./test6.sh
    command ./test7.sh
    command ./test8.sh
    command ./test9.sh
    command ./test10.sh
    passed_count=$(grep -c "Passed" output.txt)
    command rm -f output.txt
    
    if [ $passed_count -eq 10 ]; then
        echo -e "\n${bold}${green}---------------------------------------- ${passed_count}/10 TESTS PASSED ---------------------------------------${no_color}${normal}\n"
    else
        echo -e "\n${bold}${red}---------------------------------------- ${passed_count}/10 TESTS PASSED ---------------------------------------${no_color}${normal}\n"
    fi
    
    if [ $passed_count -eq 10 ]; then
        exit 0
    fi
    
popd > /dev/null