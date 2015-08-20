#!/bin/bash

#
# Copyright (c) 2015 Uli Fuchs <ufuchs@gmx.com>
# Released under the terms of the MIT License
#

# Gets the value of a given key in '/proc/meminfo'
# @param1 string  - key name, e.g. 'MemTotal'
# @return integer - value in MB
function getMemInfo() {

	local mem=$(cat /proc/meminfo | grep "$1" | awk '{print $2}')

	echo $(expr $mem / 1024)	
}

# Checks if the system provides 2048MB _free_ swap space.
# This will be tested by Oracle before the rpm installer runs.
# @return integer - 1 if less than 2048 swap space available otherwise 0
function needExtraSwapSpace() {

	local swapFree=$(getMemInfo "SwapFree")

	[ $swapFree -lt 2048 ] && echo 1 || echo 0
} 

NEED_EXTRASWAP=$(needExtraSwapSpace)
SWAPFILE=/root/swapfile

[ $NEED_EXTRASWAP -eq 1 ] && {
	echo
	echo ===================================================================================
	echo "There are only $(getMemInfo "SwapFree")MB free swap space available but it needs 2048MB."
	echo "Creating extra swap space of 2048MB. This takes some seconds..."
	sudo dd if=/dev/zero of=$SWAPFILE count=1024 bs=2097152 &> /dev/null
	sudo mkswap -c $SWAPFILE 
	sudo swapon $SWAPFILE
	echo
	swapon -s
	echo ===================================================================================
	echo
}

docker build -t "madhead/docker-oracle-xe" .

[ $NEED_EXTRASWAP -eq 1 ] && {
	echo
	echo ===================================================================================
	echo "Removing the extra swap space"
	sudo swapoff $SWAPFILE
	sudo rm -f $SWAPFILE
	echo
	swapon -s
	echo ===================================================================================
	echo
}

