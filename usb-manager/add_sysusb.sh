#!/bin/bash

# 当系统开启时，或授权软件开启时，先执行此脚本，将保证系统正常运行的USB的UID、VID添加到管控白名单中。
lsusb | grep -oP 'ID \K\S+' | cut -d: -f1 | sudo tee /etc/udev/usb_whitelist.txt
lsusb | grep -oP 'ID \K\S+' | cut -d: -f2 | sudo tee -a /etc/udev/usb_whitelist.txt
