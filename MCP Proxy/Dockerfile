ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache python3 py3-pip

RUN python3 -m pip install --user --break-system-packages mcp-proxy

ENV PATH="/root/.local/bin:$PATH"

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]