#!/bin/bash

VERSION="0.0.1"
AUTHOR="shilch"
YEAR="2016"

if [[ `uname` != "Darwin" ]]
then
  echo "macchanger is only available for Mac OS"
  exit 1
fi

if [[ $EUID -ne 0 ]]
then
  echo "Use macchanger as root: sudo macchanger [option] [device]"
  exit 1
fi

ensureDeviceExists () {
  ifconfig $1 > /dev/null 2> /dev/null
  if [[ $? -ne 0 ]]
  then
    echo "There was an error finding the device / interface. Maybe it is down?"
    exit 1
  fi
}

setMac(){
  /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -z
  ifconfig $1 ether $2
  networksetup -detectnewhardware
}

generateMac() {
  echo `openssl rand -hex 6 | sed 's/\(..\)/:\1/g; s/^.\(.\)[0-3]/\12/; s/^.\(.\)[4-7]/\16/; s/^.\(.\)[89ab]/\1a/; s/^.\(.\)[cdef]/\1e/'`
}

currentMac () {
  ETHERCURRENT=`ifconfig $1 2> /dev/null`

  if [[ $? -ne 0 ]]
  then
    echo "There was an error finding the device / interface. Maybe it is down?"
    exit 1
  fi

  echo `awk '/ether/ {print $NF}' <<< "$ETHERCURRENT"`
}

if [[ "$1" == "-v" ]] || [[ "$1" == "--version" ]]
then
  echo "Version: $VERSION, Copyright $YEAR by $AUTHOR"
elif [[ "$1" == "-s" ]] || [[ "$1" == "--show" ]]
then
  if [[ "$2" == "" ]]
  then
    echo "Please specify your device / interface"
    exit 1
  fi

  ETHERCURRENT=$(currentMac $2)

  echo "Current MAC address:    $ETHERCURRENT"

elif [[ "$1" == "-r" ]] || [[ "$1" == "--random" ]]
then
  ensureDeviceExists $2

  OLDMAC=$( currentMac $2 )

  setMac $2 $( generateMac )

  echo "Old MAC address:    $OLDMAC"
  echo "New MAC address:    $( currentMac $2 )"

elif [[ "$1" == "-m" ]] || [[ "$1" == "--mac" ]]
then
  ensureDeviceExists $3

  OLDMAC=$( currentMac $3 )

  setMac $3 $2

  echo "Old MAC address:    $OLDMAC"
  echo "New MAC address:    $( currentMac $3 )"

else
  echo "Usage: sudo macchanger [option] device"
  echo "Options:"
  echo " -r, --random         Generates a random MAC and sets it"
  echo " -m, --mac MAC        Set a custom MAC address, e.g. macchanger -m aa:bb:cc:dd:ee:ff en0"
  echo " -s, --show           Shows the current MAC address"
  echo " -v, --version        Prints version"
fi
