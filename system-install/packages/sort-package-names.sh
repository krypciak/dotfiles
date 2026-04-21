#!/bin/sh

for file in ./*.sh; do
    # shellcheck disable=SC2002
    for i in $(cat "$file" | grep "echo '" | sed 's/^[ \t]*//;s/[ \t]*$//' | awk '{print substr($0, 7, length($0)-7)}' | tr ' ' '@' | tr '\n' ' '); do
        str="$(echo "$i" | tr '@' ' ')"
        sorted="$(echo "$str"| tr ' ' '\n' | sort | tr '\n' ' ' | head -c -1)"
        sed -i "s|$str|$sorted|g" "$file"
    done
done

