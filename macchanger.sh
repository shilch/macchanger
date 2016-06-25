#!/bin/bash

VERSION="0.1.0"
AUTHOR="shilch"
YEAR="2016"

RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RS='\033[0m'

BOLD=$(tput bold)
NORMAL=$(tput sgr0)

ERROR="${BOLD}${RED}ERROR:${RS}${NORMAL}   "
INFO="${BOLD}${BLUE}INFO:${RS}${NORMAL}    "
WARNING="${BOLD}${YELLOW}WARNING:${RS}${NORMAL} "

if [[ `uname` != "Darwin" ]]
then
  printf "${ERROR}macchanger is only available for OS X / macOS\n"
  exit 1
fi

if [[ $EUID -ne 0 ]]
then
  printf "${ERROR}Use macchanger as root: sudo macchanger [option] [device]\n"
  exit 1
fi

ensureDeviceExists () {
  ifconfig $1 > /dev/null 2> /dev/null
  if [[ $? -ne 0 ]]
  then
    printf "${ERROR}Can not find device / interface. Maybe it is down?\n"
    exit 1
  fi
}

getType(){
  printf `ifconfig -v $1 | awk '/type:/ {print $NF}'` + "\n"
}

setMac(){
  TYPE=$( getType $1 )

  if [[ $TYPE == "Wi-Fi" ]]
  then
    printf "${INFO}Type of interface is Wi-Fi. Will disassociate from any network.\n"
    /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -z
  fi

  ifconfig $1 ether $2 2> /dev/null

  STATUS=$?

  if [[ $TYPE == "Wi-Fi" ]]
  then
    networksetup -detectnewhardware
  fi

  if [[ $STATUS -ne 0 ]]
  then
    printf "${ERROR}This device / interface has no MAC address to set.\n"
    exit 1
  fi
}

warnMulticast(){
  DEC=$((16#`printf $1 | awk '{print substr($0,0,2)}'`))
  if [[ $(($DEC % 2)) -ne 0 ]]
  then
    printf "${WARNING}MAC address is multicast! Setting it might not work.\n"
  fi
}

generateMac() {
  printf `openssl rand -hex 6 | sed 's/\(..\)/:\1/g; s/^.\(.\)[0-3]/\12/; s/^.\(.\)[4-7]/\16/; s/^.\(.\)[89ab]/\1a/; s/^.\(.\)[cdef]/\1e/'`
}

currentMac () {
  ETHERCURRENT=`ifconfig $1 2> /dev/null`

  if [[ $? -ne 0 ]]
  then
    printf "${ERROR}Can not find device / interface. Maybe it is down?\n"
    exit 1
  fi

  printf `awk '/ether/ {print $NF}' <<< "$ETHERCURRENT"`
}

if [[ "$1" == "-v" ]] || [[ "$1" == "--version" ]]
then
  printf "Version: $VERSION, Copyright $YEAR by $AUTHOR\n"
elif [[ "$1" == "-s" ]] || [[ "$1" == "--show" ]]
then
  if [[ "$2" == "" ]]
  then
    printf "${ERROR}Please specify your device / interface\n"
    exit 1
  fi

  ETHERCURRENT=$(currentMac $2)

  printf "Type of device:         $( getType $2 )"
  printf "Current MAC address:    $ETHERCURRENT"

elif [[ "$1" == "-r" ]] || [[ "$1" == "--random" ]]
then
  if [[ "$2" == "" ]]
  then
    printf "ERROR:   Please specify your device / interface\n"
    exit 1
  fi

  ensureDeviceExists $2

  OLDMAC=$( currentMac $2 )

  setMac $2 $( generateMac )

  CURRENTMAC=$( currentMac $2 )

  if [[ $OLDMAC == $CURRENTMAC ]]
  then
    printf "${ERROR}Can't set MAC address on this device. Ensure the driver supports changing the MAC address.\n"
    exit 1
  fi

  printf "Old MAC address:    $OLDMAC\n"
  printf "New MAC address:    $CURRENTMAC\n"
elif [[ "$1" == "-m" ]] || [[ "$1" == "--mac" ]]
then
  warnMulticast $2

  ensureDeviceExists $3

  OLDMAC=$( currentMac $3 )

  setMac $3 $2

  printf "Old MAC address:    $OLDMAC\n"
  printf "New MAC address:    $( currentMac $3 )\n"

else
  printf "Usage: sudo macchanger [option] device\n"
  printf "Options:\n"
  printf " -r, --random         Generates a random MAC and sets it\n"
  printf " -m, --mac MAC        Set a custom MAC address, e.g. macchanger -m aa:bb:cc:dd:ee:ff en0\n"
  printf " -s, --show           Shows the current MAC address\n"
  printf " -v, --version        Prints version\n"
fi
