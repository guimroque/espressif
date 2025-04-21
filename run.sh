#!/bin/bash

# Script: flash_and_build.sh
# Purpose: Build project, auto-detect USB-serial port, flash firmware, and monitor


# Load ESP-IDF environment
source ~/esp/esp-idf/export.sh

echo "🚀 Starting project build..."
idf.py build

echo ""
echo "🔍 Scanning for available USB-Serial ports..."

PORTS=($(ls /dev/tty.usbserial* /dev/tty.SLAB_USBtoUART* /dev/ttyUSB* 2>/dev/null))
PORT_COUNT=${#PORTS[@]}

if [ "$PORT_COUNT" -eq 0 ]; then
    echo "❌ No USB-Serial ports found. Please connect your ESP32."
    exit 1
elif [ "$PORT_COUNT" -eq 1 ]; then
    PORT=${PORTS[0]}
    echo "✅ Automatically detected port: $PORT"
else
    echo "⚠️ Multiple USB-Serial ports found:"
    for i in "${!PORTS[@]}"; do
        echo "$i) ${PORTS[$i]}"
    done
    echo ""
    read -p "Enter the number of the desired port: " INDEX
    PORT=${PORTS[$INDEX]}
    echo "✅ Selected port: $PORT"
fi

echo ""
echo "🚀 Flashing and monitoring on port $PORT ..."
idf.py -p "$PORT" flash monitor
