FROM ghcr.io/sparfenyuk/mcp-proxy:latest

USER root

RUN apk add –no-cache bash curl jq

RUN curl -J -L -o /tmp/bashio.tar.gz “https://github.com/hassio-addons/bashio/archive/v0.16.2.tar.gz” &&   
mkdir /tmp/bashio &&   
tar zxvf /tmp/bashio.tar.gz –strip 1 -C /tmp/bashio &&   
mv /tmp/bashio/lib /usr/lib/bashio &&   
ln -s /usr/lib/bashio/bashio /usr/bin/bashio &&   
rm -rf /tmp/bashio /tmp/bashio.tar.gz

COPY run.sh /
RUN chmod +x /run.sh

CMD [ “/run.sh” ]