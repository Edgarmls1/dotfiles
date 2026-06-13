#!/bin/bash

PATTERN=$1
FILES_QNT=$2

cd ~/Downloads/ || exit 1

for ((n=1; n<=$FILES_QNT; n++)); do
    file=$(printf "${PATTERN}%03d.zip" "$n")
    7z x "$file"
    rm "$file"
done
