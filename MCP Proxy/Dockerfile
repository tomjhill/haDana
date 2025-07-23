ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base system
ARG BUILD_ARCH=amd64
RUN \
    apk add --no-cache \
        python3=~3.11 \
        py3-pip=~23.1 \
        py3-setuptools \
        py3-wheel \
        curl \
        ca-certificates \
    && python3 -m ensurepip \
    && pip3 install --no-cache-dir --upgrade pip

# Install uv (Python package installer)
RUN pip3 install --no-cache-dir uv

# Install mcp-proxy
RUN uv tool install --python python3 mcp-proxy

# Ensure uv tools are in PATH
ENV PATH="/root/.local/bin:$PATH"

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

# Labels
LABEL \
    io.hass.name="MCP Proxy" \
    io.hass.description="Connect to MCP servers that run on SSE transport, or expose stdio servers as an SSE server" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version="1.0.0" \
    maintainer="Home Assistant Community" \
    org.opencontainers.image.title="MCP Proxy" \
    org.opencontainers.image.description="Connect to MCP servers that run on SSE transport, or expose stdio servers as an SSE server" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Home Assistant Community Add-ons" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/your-username/hassio-addons" \
    org.opencontainers.image.documentation="https://github.com/your-username/hassio-addons/blob/main/mcp-proxy/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${VCS_REF} \
    org.opencontainers.image.version=${VERSION}

CMD [ "/run.sh" ]
