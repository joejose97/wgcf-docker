FROM ubuntu:20.04


RUN apt-get update && apt-get install -y \
  curl ca-certificates \
  iproute2 net-tools iptables \
  wireguard-tools openresolv  kmod --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*
  
  
RUN curl -fsSL https://raw.githubusercontent.com/joejose97/script/master/wgcf.sh | bash && mkdir -p /wgcf

WORKDIR /wgcf

VOLUME /wgcf


COPY entry.sh /entry.sh
RUN chmod +x /entry.sh

ENTRYPOINT ["/entry.sh"]


