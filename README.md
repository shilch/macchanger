# macchanger
macchanger for macOS - Spoof / Fake MAC address  
**NEW:** Updated to support macOS Sonoma 14.4+

![](macchanger_1.png?raw=true)

## Installation
The easiest way to install `macchanger` is via [Homebrew](https://brew.sh/).
```
brew install macchanger
```

Alternatively, you can compile `macchanger` yourself:
```sh
git clone https://github.com/shilch/macchanger
cd macchanger
sudo make install
```

## Usage
Type `sudo macchanger`:
```
Usage: macchanger [option] [device]
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

## License
macchanger is licensed under GPLv2.
