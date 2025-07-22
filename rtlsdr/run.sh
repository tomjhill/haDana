#!/usr/bin/env bash

# Read configuration
CONFIG_PATH=/data/options.json

DEVICE_INDEX=$(jq -r '.device_index // 0' $CONFIG_PATH)
GAIN=$(jq -r '.gain // 0' $CONFIG_PATH)
SAMPLE_RATE=$(jq -r '.sample_rate // 2048000' $CONFIG_PATH)
FREQUENCY=$(jq -r '.frequency // 0' $CONFIG_PATH)
PPM_ERROR=$(jq -r '.ppm_error // 0' $CONFIG_PATH)
ENABLE_AGC=$(jq -r '.enable_agc // false' $CONFIG_PATH)
PORT=$(jq -r '.port // 1234' $CONFIG_PATH)
ADDRESS=$(jq -r '.address // "0.0.0.0"' $CONFIG_PATH)

# Build rtl_tcp command
RTL_TCP_CMD="rtl_tcp"
RTL_TCP_CMD="$RTL_TCP_CMD -a $ADDRESS"
RTL_TCP_CMD="$RTL_TCP_CMD -p $PORT"
RTL_TCP_CMD="$RTL_TCP_CMD -d $DEVICE_INDEX"
RTL_TCP_CMD="$RTL_TCP_CMD -s $SAMPLE_RATE"
RTL_TCP_CMD="$RTL_TCP_CMD -P $PPM_ERROR"

# Add frequency if specified (0 means no frequency set)
if [ "$FREQUENCY" -ne 0 ]; then
    RTL_TCP_CMD="$RTL_TCP_CMD -f $FREQUENCY"
fi

# Add gain (0 means auto gain)
if [ "$GAIN" -eq 0 ]; then
    RTL_TCP_CMD="$RTL_TCP_CMD -g 0"
else
    RTL_TCP_CMD="$RTL_TCP_CMD -g $GAIN"
fi

# Add AGC flag if enabled
if [ "$ENABLE_AGC" = true ]; then
    RTL_TCP_CMD="$RTL_TCP_CMD -a"
fi

echo "Starting RTL-SDR TCP server..."
echo "Command: $RTL_TCP_CMD"

# Check if RTL-SDR device is available
rtl_test -t 2>&1 | grep -q "Found"
if [ $? -ne 0 ]; then
    echo "Error: No RTL-SDR device found!"
    echo "Please ensure your RTL-SDR dongle is connected and recognized by the system."
    exit 1
fi

# Start rtl_tcp
exec $RTL_TCP_CMD