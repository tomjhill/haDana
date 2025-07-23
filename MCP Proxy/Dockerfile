ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache python3 py3-pip py3-venv coreutils bash curl

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --no-cache-dir mcp-proxy

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]