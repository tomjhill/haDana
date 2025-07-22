ARG BUILD_FROM
FROM $BUILD_FROM

# Install required packages
RUN apk add --no-cache \
    rtl-sdr \
    libusb \
    bash

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

# Expose rtl_tcp port
EXPOSE 1234

CMD [ "/run.sh" ]