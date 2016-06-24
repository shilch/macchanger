# macchanger
macchanger for Mac OS - Spoof / Fake MAC address

## Installation
```sh
sudo sh -c "curl https://raw.githubusercontent.com/shilch/macchanger/master/macchanger.sh > /usr/local/bin/macchanger && chmod +x /usr/local/bin/macchanger"
```

## Usage
Type `sudo macchanger`:
```
Usage: sudo macchanger [option] device
Options:
 -r, --random         Generates a random MAC and sets it
 -m, --mac MAC        Set a custom MAC address, e.g. macchanger -m aa:bb:cc:dd:ee:ff en0
 -s, --show           Shows the current MAC address
 -v, --version        Prints version
```

### Set custom MAC
`sudo macchanger -m aa:bb:cc:dd:ee:ff en0`

### Set random MAC
`sudo macchanger -r en0`

## To do
- Reset to permanent MAC address
- Only restart WIFI service if device / interface is a wifi device
