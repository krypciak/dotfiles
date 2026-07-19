#!/bin/bash
if ! bash ~/.config/hypr/run.sh; then
    if ! bash ~/.config/awesome/run/run.sh; then
        if ! cage -d -s -- alacritty; then
            if ! zsh; then
                bash
            fi
        fi
    fi
fi
