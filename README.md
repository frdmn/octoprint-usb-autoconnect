# octoprint-usb-autoconnect

![](https://up.frd.mn/wmXdUnVUpC.gif)

Simple bash script (and systemd service) to automatically reconnect the serial connection of OctoPrint using REST whenever the USB cable of the printer is getting plugged in. This is accomplished by a custom udev rule that hooks into the USB subsystem and gets triggered whenever a certain device is found.

## Installation

1. Clone this repository:

    ```shell
    git clone https://github.com/frdmn/octoprint-usb-autoconnect /usr/local/src/octoprint-usb-autoconnect
    ```

2. Obtain your API key from OctoPrint settings, copy and adjust the default configuration file:

    ```shell
    cp /usr/local/src/octoprint-usb-autoconnect/octoprint_usb_autoconnect.conf.sample /usr/local/src/octoprint-usb-autoconnect/octoprint_usb_autoconnect.conf
    vi /usr/local/src/octoprint-usb-autoconnect/octoprint_usb_autoconnect.conf
    ```

3. Symlink (or copy) script and service:

    ```shell
    ln -s /usr/local/src/octoprint-usb-autoconnect/octoprint_usb_autoconnect /usr/local/bin/octoprint_usb_autoconnect
    ln -s /usr/local/src/octoprint-usb-autoconnect/octoprint_usb_autoconnect.service /etc/systemd/system/octoprint_usb_autoconnect.service
    ```

4. Create the `udev` USB hook:

    ```shell
    vi /etc/udev/rules.d/40-octoprint_usb_autoconnect.rules
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
