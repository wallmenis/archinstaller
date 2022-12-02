#!/bin/bash

ping -c 3 archlinux.org > /dev/null

if [[ $? -eq 0 ]]; then
echo "internet connection established"
else
echo "no internet connection found"
fi

echo "Please format the drives and press Ctrl+D when you're done"

bash

echo "Is the following drive formatting ok for you?"
lsblk

