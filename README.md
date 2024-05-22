# usb-manager
This is a solution which solved usb-class management problem in linux. It can authorized you trust usb deviecs by a whitelist,or it disauthorized usb devices that you cannot trust and cannot use it in your system.

## 1、创建白名单文件
首先，创建一个白名单文件，比如：/etc/udev/usb_whitelist.txt，其中包含允许访问的VID和PID：
  1234
  5678

## ２、编写udev规则
在/etc/udev/rules.d/下创建99-usb-vid-pid-check.rules规则文件，编写udev规则：
  ACTION=="add",SUBSYSTEM=="usb",RUN+="/etc/udev/usb_check %s{idVendor} %s{idProduct} $env{DEVPATH}"

DEVPATH环境变量包含了设备在/sys文件系统中的路径。例如/devices/pci0000:00/0000:00:15.0/0000:03:00.0/usb4/4-1，路径下的文件代表usb设备文件以及usb设备接口文件。

完整路径为:/sys/devices/pci0000:00/0000:00:15.0/0000:03:00.0/usb4/4-1，此路径为设备树路径，即连接在usb4总线上的第一个设备。第0个设备为usb3.0主控制器（usb4/4-0:1.0，第0个设备的第1个接口）。
在此文件下，有很多子文件，分别代表此usb设备的各个属性值，其中authorized文件代表此设备是否被授权使用。（usbcore内核模块）

## 3、编写授权控制脚本
脚本的输入为先前创建的白名单文件，脚本输出为在系统日志中打印信息，可通过 sudo cat /var/log/syslog | grep root来查看usb_check.sh脚本输出信息。

后续扩展：当装载到一个新设备上时，首先需要将现在已经连接在系统的usb设备全部授权（能否全部将已经连接的设备的authorized设置为1，然后将他们的vid，pid写入usb_whitelist中），然后拒绝这之后的全部设备。之后连入的设备均需要进行授权后，才能被系统访问。

## 4、编写系统或软件启动时系统USB设备认证脚本
在/etc/udev/下创建add_sysusb.sh脚本，里面编写脚本。当系统开启时，或授权软件开启时，先执行此脚本，将保证系统正常运行的USB的UID、VID添加到管控白名单中。
