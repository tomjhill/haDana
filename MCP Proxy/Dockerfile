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

CMD [ “/run.sh” ]