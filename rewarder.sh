#!/bin/bash

# Automatic Bing Rewards script
# - requires cookies.txt
# - performs both PC and mobile searches
#   - 30 times for PC, 20 for mobile

USERAGENT_PC="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:53.0) Gecko/20100101 Firefox/53.0"
USERAGENT_MOBILE="Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1"

ALL_NON_RANDOM_WORDS=/usr/share/dict/words
WORD_COUNT=`cat $ALL_NON_RANDOM_WORDS | wc -l`

# check if cookies.txt present
if [ ! -f cookies.txt ]; then
    echo "Please provide cookies.txt before continuing."
    exit
fi

echo -ne "PC Search 0 / 30\r"
for i in `seq 0 30`; do
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
    echo -ne "PC Search: $i / 30\r"
done

echo -ne "\nMobile Search: 0 / 20\r"
for i in `seq 0 20`; do
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
    echo -ne "Mobile Search: $i / 20\r"
done

echo -ne "\nDone!"
