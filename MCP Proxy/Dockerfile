ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add –no-cache python3 py3-pip
RUN pip3 install –user pipx
RUN /root/.local/bin/pipx install mcp-proxy

ENV PATH=”/root/.local/bin:$PATH”

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ “/run.sh” ]