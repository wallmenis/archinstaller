#!/bin/bash

ping -c 3 archlinux.org > /dev/null

if [[ $? -eq 0 ]]; then
    echo "Internet connection established!"
else
    echo "No internet connection found! Please connect to a network with internet and run this script again"
    exit
fi
pacman-key --init
pacman-key --populate
pacman -Syy
RET=0
while [ ! $RET -eq 1 ]; do
    echo "Please enter additional packages you would like to include after the installation. [package name/n] "
    read PACKAGES_EXTRA
    if [ ${#PACKAGES_EXTRA[@]} -eq 1 ]; then
        if [ ! -z $PACKAGES_EXTRA ];then
            if [ $PACKAGES_EXTRA != "n" ]; then
                RET=0
                for PACKAGE_EXTRA in ${PACKAGES_EXTRA[@]}
                do
                    INP=$(pacman -Ss $PACKAGE_EXTRA | grep -w $PACKAGE_EXTRA | wc -l)
                    if [ $INP -gt $RET ]; then
                        RET=$INP
                    fi
                done
                if [ ! $RET -eq 1 ]; then
                    echo "One or more packages not found"
                fi
            else
                RET=1
                echo "No extra packages sellected."
            fi
        else
            RET=1
            echo "No extra packages sellected."
        fi
    else
        RET=0
        for PACKAGE_EXTRA in ${PACKAGES_EXTRA[@]}
        do
            INP=$(pacman -Ss $PACKAGE_EXTRA | grep -w $PACKAGE_EXTRA | wc -l)
            if [ $INP -gt $RET ]; then
                RET=$INP
            fi
        done
        if [ ! $RET -eq 1 ]; then
            echo "One or more packages not found"
        fi
    fi 
done

INP="n"
while [ $INP != "y" ]; do
    echo "Will now enter disk formating. Would you like a manual[1] or guided[2] install? [1/2] [default=2]"
    read INP
    if [[ $INP -eq 1 ]]; then
        echo "Entering manual disk formating. You are responsible for all disk formating (including setting up filesystems). When done, you will be prompted to declare your root partition.Press Ctrl+D when done."
        bash
        echo "Please enter root drive: "
        read ROOTDRV
#        echo "Is there a swap drive? [drive path/n]"
#        read INP
#        SWAPDRV="NULL"
#        if [ $INP != "n" ]; then
#            SWAPDRV=$INP
#        fi
        
    else
        echo "Entering guided disk formating. Please select drive:"
    fi
    echo "Is the following drive formatting ok for you? [y/n]"
    lsblk
    read INP
done
echo "Now installing system to drive."
mount $ROOTDRV /mnt

pacstrap -K /mnt base base-devel linux linux-firmware nano grub networkmanager $PACKAGES_EXTRA

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

echo "Please enter a password for root user."
passwd

