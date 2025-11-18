#!/bin/bash

echo "===================================="
echo "           KRIA KV260 
echo "===================================="

echo ""
echo ">>> Checking system info..."
uname -a
cat /etc/os-release

echo ""
echo ">>> Checking storage devices..."
lsblk

echo ""
echo ">>> Checking eMMC speed..."
sudo hdparm -tT /dev/mmcblk0 2>/dev/null

echo ""
echo ">>> Checking SD card speed..."
sudo hdparm -tT /dev/mmcblk1 2>/dev/null

echo ""
echo ">>> Checking Ethernet (ping test)..."
ping -c 4 google.com

echo ""
echo ">>> Checking USB devices..."
lsusb

echo ""
echo ">>> Checking FPGA available apps..."
sudo xmutil listapps

echo ""
echo ">>> Loading FPGA DPU app..."
sudo xmutil loadapp kv260-dpu
if [ $? -eq 0 ]; then
    echo "DPU bitstream loaded OK!"
else
    echo "DPU load FAILED!"
fi

echo ""
echo ">>> Checking I2C buses..."
i2cdetect -y 0
i2cdetect -y 1

echo ""
echo ">>> Checking DDR memory (quick test)..."
sudo memtester 50M 1

echo ""
echo ">>> Checking USB camera existence..."
if ls /dev/video0 1> /dev/null 2>&1; then
    echo "USB Camera detected: /dev/video0"
    echo "Running simple capture test..."
    ffmpeg -f v4l2 -i /dev/video0 -vframes 1 test_image.jpg
    echo "Saved capture to test_image.jpg"
else
    echo "No USB Camera found"
fi

echo ""
echo ">>> Test Complete!"
echo "===================================="
