# RTL-SDR Server Home Assistant Add-on

This add-on runs an RTL-SDR TCP server (rtl_tcp) that allows you to stream radio data from an RTL-SDR dongle over your network.

## Installation

1. Ensure your RTL-SDR dongle is connected to your Home Assistant host
2. Add this repository to your Home Assistant add-on store
3. Install the RTL-SDR Server add-on
4. Configure the add-on (see Configuration section)
5. Start the add-on

## Configuration

- **device_index**: RTL-SDR device index (default: 0)
- **gain**: Tuner gain in dB (0 for auto gain, max ~50)
- **sample_rate**: Sample rate in Hz (default: 2048000)
- **frequency**: Initial frequency in Hz (0 to not set)
- **ppm_error**: Frequency correction in PPM
- **enable_agc**: Enable automatic gain control
- **port**: TCP port for rtl_tcp server (default: 1234)
- **address**: Bind address (default: 0.0.0.0)

## Usage

Once started, you can connect to the RTL-SDR server using any compatible SDR software:

- **SDR#**: Use RTL-SDR (TCP) source with your Home Assistant IP and port 1234
- **GQRX**: Use rtl_tcp source with your Home Assistant IP and port 1234
- **CubicSDR**: Add network RTL-SDR device

Example connection string: `192.168.1.100:1234`

## Troubleshooting

### No RTL-SDR device found
- Ensure your RTL-SDR dongle is properly connected
- Check that the add-on has USB access enabled
- Try unplugging and reconnecting the dongle
- Check Home Assistant logs for USB device detection

### Connection refused
- Verify the add-on is running
- Check that the port is not blocked by a firewall
- Ensure you're using the correct IP address

### Poor reception
- Adjust the gain setting (try different values)
- Check your antenna connection
- Consider the ppm_error correction if frequency is off

## Supported RTL-SDR Dongles

- Generic RTL2832U DVB-T dongles
- RTL-SDR.com V3
- NooElec NESDR series
- FlightAware Pro Stick series
- Most other RTL2832U-based receivers

## Security Notice

The rtl_tcp protocol is unencrypted. Only use this on trusted networks.
```

## 6. Build Arguments for Multi-arch Support

For the base image in Dockerfile, Home Assistant will automatically substitute the correct base image based on the architecture. The typical base images are:

- `homeassistant/amd64-base`
- `homeassistant/armv7-base`
- `homeassistant/aarch64-base`
- `homeassistant/armhf-base`
- `homeassistant/i386-base`