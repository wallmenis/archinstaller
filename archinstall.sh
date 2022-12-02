#!/bin/bash

ping -c 3 archlinux.org > /dev/null

if [[ $? -eq 0 ]]; then
    echo "Internet connection established!"
else
    echo "No internet connection found! Please connect to a network with internet and run this script again"
    exit
fi
INP="n"
while [ $INP != "y" ]; do
    echo "Will now enter disk formating. Would you like a manual[1] or guided[2] install? [1/2] [default=2]"
    read $INP
    if [[ $INP -eq 1 ]]; then
        echo "Entering manual disk formating. Press Ctrl+D when done."
        bash
    else
        echo "Entering guided disk formating. Please select drive:"
    fi
    echo "Is the following drive formatting ok for you? [y/n]"
    lsblk
    read INP
done