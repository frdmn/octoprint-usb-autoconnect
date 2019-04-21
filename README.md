# octoprint-usb-autoconnect

[![](https://up.frd.mn/nnTh5bQhjn.jpg)](https://up.frd.mn/21aibgyD15.mp4)
<sup><sub>(Click the picture above for a short demonstration video)</sup></sub>

Simple bash script (and systemd service) to automatically reconnect the serial connection of OctoPrint using REST whenever the USB cable of the printer is getting plugged in. This is accomplished by a custom udev rule that hooks into the USB subsystem and gets triggered whenever a certain device is found.

## Installation

1. On your OctoPrint/OctoPi, clone this repository - make sure you're working as `root` user:

    ```shell
    sudo su
    git clone https://github.com/frdmn/octoprint-usb-autoconnect /usr/local/src/octoprint-usb-autoconnect
    ```

2. Obtain your API key from [OctoPrint settings](https://up.frd.mn/Fcjb2ihnru.jpg), copy and adjust the default configuration file:

    ```shell
    cp /usr/local/src/octoprint-usb-autoconnect/octoprint_usb_autoconnect.conf.sample /usr/local/src/octoprint-usb-autoconnect/octoprint_usb_autoconnect.conf
    editor /usr/local/src/octoprint-usb-autoconnect/octoprint_usb_autoconnect.conf
    ``` 

3. Symlink (or copy) script and service:

    ```shell
    ln -s /usr/local/src/octoprint-usb-autoconnect/octoprint_usb_autoconnect /usr/local/bin/octoprint_usb_autoconnect
    ln -s /usr/local/src/octoprint-usb-autoconnect/octoprint_usb_autoconnect.service /etc/systemd/system/octoprint_usb_autoconnect.service
    ```

4. Create the `udev` USB hook:

    ```shell
    editor /etc/udev/rules.d/40-octoprint_usb_autoconnect.rules
    ```

    ```
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6001", RUN+="/bin/systemctl --no-block start octoprint_usb_autoconnect.service"
    ```

    (Please note that the hook above is for an Creality Ender-3, if you have a different printer you can use `lsusb` and `lsusb -vs 00X:00Y` to find the proper `idVendor` and `idProduct` numbers.)

5. Activate new `udev` rules and restart service

    ```shell
    udevadm control --reload-rules
    systemctl restart systemd-udevd.service
    ```

## Troubleshooting

### Find out `idVendor` / `idProduct`

The script was made to work with an Creality Ender 3. In case you have a different printer, you might have to adjust the `udev` rules to reflect the proper information of your printers USB interface. Follow the steps below to find out the bus and device information of said port:

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

3. Now we just need to adjust (or create) the `udev` rule to reflect the new vendor and product values. Open the `/etc/udev/rules.d/40-octoprint_usb_autoconnect.rules` file with a text editor of your choice:


	Take a look at [step 4 in the installation guide](#installation).

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

1.0.0

## License

[MIT](LICENSE)
