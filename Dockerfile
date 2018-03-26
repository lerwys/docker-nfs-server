FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive

RUN echo "nameserver 10.0.0.71" > /etc/resolv.conf && \
    apt-get update -qq && \
    apt-get install -y \
    nfs-kernel-server \
    runit inotify-tools -qq && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /exports

RUN mkdir -p /etc/sv/nfs
ADD nfs.init /etc/sv/nfs/run
ADD nfs.stop /etc/sv/nfs/finish

ADD nfs_setup.sh /usr/local/bin/nfs_setup

RUN echo "nfs             2049/tcp" >> /etc/services
RUN echo "nfs             111/udp" >> /etc/services

VOLUME /exports

EXPOSE 111/udp 2049/tcp

ENTRYPOINT ["/usr/local/bin/nfs_setup"]
