#!/bin/bash

# 检查 VID 和 PID 是否为空
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
    echo "Error: VID and PID must not be empty."
    exit 1
fi

# 定义一个函数来检查设备是否被授权
is_authorized() {
    # 假设我们有一个白名单的路径
    whitelist_path='/etc/udev/usb_whitelist.txt'

    # 读取白名单文件中的 VID 和 PID
    whitelist=$(cat $whitelist_path)

    # 检查设备是否在白名单中
    if [[ $whitelist == *"$1"* && $whitelist == *"$2"* ]]; then
        return 0
    else
        return 1
    fi
}

# 获取设备的 vid 和 pid
vid=$1
pid=$2
devpath=$3
kernel_name=$4

logger "this is a shell test by cwh, vendorId is $vid, productId is $pid, devpath is $devpath, kernel_name is $kernel_name"

if is_authorized $vid $pid; then
    logger "USB device with VID $vid and PID $pid is authorized."
    echo '1' > /sys${devpath}/authorized
    # 在这里添加授权设备的处理逻辑
else
    logger "USB device with VID $vid and PID $pid is NOT authorized. Access denied."
    echo '0' > /sys${devpath}/authorized
    # 在这里添加未授权设备的处理逻辑

    # 可以执行系统命令来阻止设备，例如：
    # echo 'deny' > /sys/kernel/security/tomoyo/denied_message
fi
