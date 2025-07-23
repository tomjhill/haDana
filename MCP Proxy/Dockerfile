FROM ghcr.io/sparfenyuk/mcp-proxy:latest

USER root

RUN apk add --no-cache bash curl jq

COPY run.sh /
RUN chmod +x /run.sh

CMD [ "/run.sh" ]