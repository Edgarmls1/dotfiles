#! /bin/bash

while read extention; do
    code --install-extension $extention
done < extentions.txt
