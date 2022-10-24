#!/bin/bash
# https://libreddit.kavin.rocks/r/awesomewm/comments/h07f5y/does_awesome_support_window_swallowing/
# Thanks to u/nfjlanlsad
ppid() { 
    printf "$(ps -o ppid= -p $1)" | xargs 
}

gppid() { 
    PARENT=$(ps -o ppid= -p $1) 
    GRANDPARENT=$(ps -o ppid= -p $PARENT) 
    printf "$GRANDPARENT" | xargs 
}

$@
