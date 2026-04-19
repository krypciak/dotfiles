#!/bin/bash
bash ~/.config/hypr/run.sh
if [ "$?" != 0 ]; then
    bash ~/.config/awesome/run/run.sh
fi
