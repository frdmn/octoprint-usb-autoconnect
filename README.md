# octop*-

[![](https://up.frd.mn/nnTh5bQhjn.jpg)](https://up.frd.mn/21aibgyD15.mp4)
<sup><sub>(Click the picture above for a short demonstration video)</sup></sub>

Simple bash script (and systemd service) to automatically reconnect the serial connection of OctoPrint using REST whenever the USB cable of the printer is getting plugged in. This is accomplished by a custom udev rule that hooks into the USB subsystem and gets triggered whenever a certain device is found.

## Installation

1. On your OctoPrint/OctoPi, 

    ```shell
    git clone https://github.com/richardturnbull/octoprint-usb-restart-firmware 
    cd octoprint-usb-restart-firmware
    ```

2. Obtain your API key from [OctoPrint settings](https://up.frd.mn/Fcjb2ihnru.jpg), copy and adjust the default configuration file:

    ```shell
    cp octoprint-usb-restart-firmware/octoprint-usb-restart-firmware.conf.sample octoprint-usb-restart-firmware.conf
    editor octoprint-usb-restart-firmware.conf
    ```

4. Ensure the UDEV device & vendor ID is correct in `40-octoprint_usb_restart_firmware.rules` (see Troubleshooting below):

    ```shell
    lsusb 
    editor 40-octoprint_usb_restart_firmware.rules
    ```

5. Run installer script as root

    ```shell
    sudo ./install.sh
    
    ```

## Troubleshooting

### Find out `idVendor` / `idProduct`

The script was made to work with an Creality Ender 3 with a Silent Mainboard. In case you have a different printer, you might have to adjust the `udev` rules to reflect the proper information of your printers USB interface. Follow the steps below to find out the bus and device information of said port:

1. Use `lsusb` to identify your printer interface:

	```shell
	pi@octopi:~ $ lsusb
	Bus 001 Device 025: ID 0403:6001 Future Technology Devices International, Ltd FT232 USB-Serial (UART) IC
	Bus 001 Device 003: ID 0424:ec00 Standard Microsystems Corp. SMSC9512/9514 Fast Ethernet Adapter
	Bus 001 Device 002: ID 0424:9514 Standard Microsystems Corp. SMC9514 Hub
	Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
	```

	I'm going to use my Ender 3 in this example again, so in this case it's the first line in the command output. Write down the bus and device information:

	- Bus: `001`
	- Device: `025`

2. Display the desired `idVendor` and `idProduct` values. Make sure to pass your bus and device information to the `-s` switch from the previous command:

	```shell
	pi@octopi:~ $ lsusb -vs 001:025 | grep "idVendor\|idProduct"
	Couldn't open device, some information will be missing
	  idVendor           0x0403 Future Technology Devices International, Ltd
	  idProduct          0x6001 FT232 USB-Serial (UART) IC
	```

	The numberes are prefixed with a `0x` to indicate that this is a hex value. You can ignore that and just note down everything that follows:

	- `idVendor`: `0403`
	- `idProduct`: `6001`

3. Now we just need to adjust (or create) the `udev` rule to reflect the new vendor and product values. Open the `/etc/udev/rules.d/40-octoprint-usb-restart-firmware.rules` file with a text editor of your choice:


	Take a look at [step 4 in the installation guide](#installation).

### Run script manually, verbose mode

```shell
pi@octopi:~ $ bash -x /usr/local/bin/octoprint-usb-restart-firmware
+ CONFIGFILE=/usr/local/src/octoprint-usb-restart-firmware/octoprint-usb-restart-firmware.conf
+ '[' '!' -f /usr/local/src/octoprint-usb-restart-firmware/octoprint-usb-restart-firmware.conf ']'
+ . /usr/local/src/octoprint-usb-restart-firmware/octoprint-usb-restart-firmware.conf
++ APIKEY=XXX
++ OCTOHOST=http://localhost
+ curl -siL -X POST -H 'X-Api-Key: XXX' -H 'Content-Type: application/json' http://localhost/api/connection -d '{"command":"connect"}'
HTTP/1.1 204 NO CONTENT
Content-Length: 0
X-Robots-Tag: noindex, nofollow, noimageindex
Expires: -1
Pragma: no-cache
Cache-Control: pre-check=0, no-cache, no-store, must-revalidate, post-check=0, max-age=0
X-Clacks-Overhead: GNU Terry Pratchett
Content-Type: text/html; charset=utf-8
pi@octopi:~ $
```

### Run service manually

```
pi@octopi:~ $ sudo systemctl --no-block start octoprint-usb-restart-firmware.service
pi@octopi:~ $
```

### Check `udev` monitor

Show all events of the USB subsystem:

```
pi@octopi:~ $ udevadm monitor --subsystem-match=usb
monitor will print the received events for:
UDEV - the event which udev sends out after rule processing
KERNEL - the kernel uevent

[plug in USB device]

KERNEL[4754.758134] add      /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.3 (usb)
KERNEL[4754.766885] add      /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.3/1-1.3:1.0 (usb)
UDEV  [4754.817972] add      /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.3 (usb)
UDEV  [4754.821559] add      /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.3/1-1.3:1.0 (usb)
^C
pi@octopi:~ $
```

## Contributing

1. Fork it
2. Create your feature branch:

```shell
git checkout -b feature/my-new-feature
```

3. Commit your changes:

```shell
git commit -am 'Add some feature'
```

4. Push to the branch:

```shell
git push origin feature/my-new-feature
```

5. Submit a pull request

## Requirements / Dependencies

* OctoPrint
* systemd / udev compatible system

## Version

1.0.2

## License

[MIT](LICENSE)
