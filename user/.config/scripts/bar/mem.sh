#!/bin/sh
free -h | awk '/^Mem/ {print $3}' | sed 's/i//g'

