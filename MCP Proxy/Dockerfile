FROM ghcr.io/sparfenyuk/mcp-proxy:latest

USER root

RUN apk add --no-cache bash curl jq

COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

ENTRYPOINT ["/usr/local/bin/run.sh"]