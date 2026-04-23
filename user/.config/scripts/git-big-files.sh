#!/bin/bash
git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | sort -k3 -nr | head -20 | awk '{size=$3; if(size>1024*1024) hum=sprintf("\033[1;32m%6.1f MB\033[0m", size/1024/1024); else hum=sprintf("\033[1;32m%6.0f KB\033[0m", size/1024); printf "%s %s %s\n", hum, $1, substr($0, index($0,$4))}'
