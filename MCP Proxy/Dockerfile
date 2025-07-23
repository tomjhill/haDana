ARG BUILD_FROM
FROM $BUILD_FROM

ARG BUILD_ARCH=amd64

RUN apk add –no-cache python3 py3-pip py3-setuptools py3-wheel curl ca-certificates

RUN pip3 install –no-cache-dir –upgrade pip

RUN pip3 install –no-cache-dir uv

RUN uv tool install –python python3 mcp-proxy

ENV PATH=”/root/.local/bin:$PATH”

COPY run.sh /
RUN chmod a+x /run.sh

LABEL io.hass.name=“MCP Proxy”
LABEL io.hass.description=“Connect to MCP servers that run on SSE transport, or expose stdio servers as an SSE server”
LABEL io.hass.arch=”${BUILD_ARCH}”
LABEL io.hass.type=“addon”
LABEL io.hass.version=“1.0.0”
LABEL maintainer=“Home Assistant Community”
LABEL org.opencontainers.image.title=“MCP Proxy”
LABEL org.opencontainers.image.description=“Connect to MCP servers that run on SSE transport, or expose stdio servers as an SSE server”
LABEL org.opencontainers.image.vendor=“Home Assistant Community Add-ons”
LABEL org.opencontainers.image.authors=“Home Assistant Community Add-ons”
LABEL org.opencontainers.image.licenses=“MIT”
LABEL org.opencontainers.image.url=“https://addons.community”
LABEL org.opencontainers.image.source=“https://github.com/your-username/hassio-addons”
LABEL org.opencontainers.image.documentation=“https://github.com/your-username/hassio-addons/blob/main/mcp-proxy/README.md”

CMD [ “/run.sh” ]