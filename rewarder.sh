#!/bin/bash

# Automatic Bing Rewards script
# - requires cookies.txt
# - performs both PC and mobile searches
#   - 30 times for PC, 20 for mobile

USERAGENT_PC="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:53.0) Gecko/20100101 Firefox/53.0"
USERAGENT_MOBILE="Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1"

ALL_NON_RANDOM_WORDS="/usr/share/dict/words"
WORD_COUNT=`cat $ALL_NON_RANDOM_WORDS | wc -l`

# check if cookies.txt present
check_cookies() {
    if [[ ! -f cookies.txt ]]; then
        echo -ne "\e[31mERROR:\e[0m please provide cookies.txt before continuing.\n"
        exit
    fi
}

pc_search() {
    check_cookies
    echo -ne "\e[93mPC Search:\e[0m 0 / $1\r"
    for i in `seq 1 $1`; do
        # generate a random word
        RAND_NUM=`od -N3 -An -i /dev/urandom | awk -v f=0 -v r="$WORD_COUNT" '{printf "%i\n", f + r * $1 / 16777216}'`
        KEYWORD=`sed -n ${RAND_NUM}p $ALL_NON_RANDOM_WORDS`

        # make request
        #echo "wget -qO- -U \"${USERAGENT_PC}\" --load-cookies=cookies.txt \"www.bing.com/search?q=${KEYWORD}\" &> /dev/null"
        wget -qO- -U "${USERAGENT_PC}" --load-cookies=cookies.txt "www.bing.com/search?q=${KEYWORD}" &> /dev/null

        # sleep for a random time between 3.0 to 4.9
        SLEEPTIME=$[(($RANDOM % 2) + 3)]
        SLEEPTIME_FRAC=$[$RANDOM % 10]
        sleep ${SLEEPTIME}.${SLEEPTIME_FRAC}

        # counter
        echo -ne "\e[93mPC Search:\e[0m $i / $1\r"
    done
    echo -ne "\n"
}

mobile_search() {
    check_cookies
    echo -ne "\e[93mMobile Search:\e[0m 0 / $1\r"
    for i in `seq 1 $1`; do
        # generate a random word
        RAND_NUM=`od -N3 -An -i /dev/urandom | awk -v f=0 -v r="$WORD_COUNT" '{printf "%i\n", f + r * $1 / 16777216}'`
        KEYWORD=`sed -n ${RAND_NUM}p $ALL_NON_RANDOM_WORDS`

        # make request
        #echo "wget -qO- -U \"${USERAGENT_MOBILE}\" --load-cookies=cookies.txt \"www.bing.com/search?q=${KEYWORD}\" &> /dev/null"
        wget -qO- -U "${USERAGENT_MOBILE}" --load-cookies=cookies.txt "www.bing.com/search?q=${KEYWORD}" &> /dev/null

        # sleep for a random time between 3.0 to 4.9
        SLEEPTIME=$[(($RANDOM % 2) + 3)]
        SLEEPTIME_FRAC=$[$RANDOM % 10]
        sleep ${SLEEPTIME}.${SLEEPTIME_FRAC}

        # counter
        echo -ne "\e[93mMobile Search:\e[0m $i / $1\r"
    done
    echo -ne "\n"
}

show_help() {
    echo -ne "Bing Rewarder: performs automatic searches on Bing to earn Microsoft Rewards points.\n"
    echo -ne "\n"
    echo -ne "Usage:\n"
    echo -ne "  bash rewarder.sh [-p <argument>] [-m <argument>]\n"
    echo -ne "  bash rewarder.sh -h | --help\n"
    echo -ne "\n"
    echo -ne "Options:\n"
    echo -ne "  -p, --pc      Perform specified number of PC searches.\n"
    echo -ne "  -m, --mobile  Perform specified number of mobile searches.\n"
    echo -ne "  -h, --help    Display this help page.\n"
    echo -ne "\n"
    echo -ne "Note: if no options given, will perform according default set up (30 PC searches and 20 mobile searches).\n"
    echo -ne "\n"
}

# command-line arguments handling
if [[ $1 == "" ]]; then
    pc_search 30
    mobile_search 20
elif [[ $1 == "-h" || $1 == "--help" ]]; then
    show_help
else
    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            -p|--pc)
                if [[ "$2" == "" ]]; then
                    echo -ne "ERROR: number of times not provided\n"
                    exit
                elif [[ ! $2 =~ ^[0-9]+$ ]]; then
                    echo -ne "ERROR: number of times must be a positive integer number\n"
                    exit
                else
                    pc_search $2
                fi
                shift;shift;;
            -m|--mobile)
                if [[ $2 == "" ]]; then
                    echo -ne "\e[31mERROR:\e[0m number of times not provided.\n"
                    exit
                elif [[ ! $2 =~ ^[0-9]+$ ]]; then
                    echo -ne "\e[31mERROR:\e[0m number of times must be a positive integer number.\n"
                    exit
                else
                    mobile_search $2
                fi
                shift;shift;;
            *)
                echo -ne "\e[31mERROR:\e[0m invalid argument(s) given.\n"
                exit;;
        esac
    done
fi
