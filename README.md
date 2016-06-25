# macchanger
macchanger for Mac OS - Spoof / Fake MAC address

![](macchanger_1.png?raw=true)

## Installation
```sh
sudo sh -c "curl https://raw.githubusercontent.com/shilch/macchanger/master/macchanger.sh > /usr/local/bin/macchanger && chmod +x /usr/local/bin/macchanger"
```

## Usage
Type `sudo macchanger`:
```
Usage: sudo macchanger [option] [device]
Options:
 -r, --random         Generates a random MAC and sets it
 -m, --mac MAC        Set a custom MAC address, e.g. macchanger -m aa:bb:cc:dd:ee:ff en0
 -p, --permanent      Resets the MAC address to the permanent
 -s, --show           Shows the current MAC address
 -v, --version        Prints version
```

### Set custom MAC
`sudo macchanger -m aa:bb:cc:dd:ee:ff en0`

### Set random MAC
`sudo macchanger -r en0`

### Reset to permanent MAC
`sudo macchanger -p en0`

## To do
- Option to set MAC address at startup
- Add Manufacturer info
