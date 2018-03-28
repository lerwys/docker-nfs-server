FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive

RUN echo "nameserver 10.0.0.71" > /etc/resolv.conf && \
    apt-get update && \
    apt-get install -y \
    nfs-kernel-server \
    netbase \
    runit \
    inotify-tools && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /exports

RUN mkdir -p /etc/sv/nfs
ADD nfs.init /etc/sv/nfs/run
ADD nfs.stop /etc/sv/nfs/finish

ADD nfs_setup.sh /usr/local/bin/nfs_setup

RUN echo "rpc.nfsd 2049/tcp" >> /etc/services && \
    echo "nfs 111/udp" >> /etc/services && \
    echo "rpc.statd-bc 32765/tcp" >> /etc/services && \
    echo "rpc.statd-bc 32765/udp" >> /etc/services && \
    echo "rpc.statd 32766/tcp" >> /etc/services && \
    echo "rpc.statd 32766/udp" >> /etc/services && \
    echo "rpc.mountd 32767/tcp" >> /etc/services && \
    echo "rpc.mountd 32767/udp" >> /etc/services && \
    echo "rcp.lockd 32768/tcp" >> /etc/services && \
    echo "rcp.lockd 32768/udp" >> /etc/services && \
    echo "rpc.quotad 32769/tcp" >> /etc/services && \
    echo "rpc.quotad 32769/udp" >> /etc/services && \
    sed -i -e 's/STATDOPTS=\(.*\)/STATDOPTS="\1 --port 32765 --outgoing-port 32766"/g' /etc/default/nfs-common && \
    sed -i -e 's/RPCMOUNTDOPTS="\(.*\)"/RPCMOUNTDOPTS="\1 -p 32767"/g' /etc/default/nfs-kernel-server && \
    sed -i -e 's/RPCRQUOTADOPTS="\(.*\)"/RPCRQUOTADOPTS="\1 -p 32769"/g' /etc/default/quota || \
        echo 'RPCRQUOTADOPTS="-p 32769"' >>  /etc/default/quota && \
    mkdir -p /etc/modprobe.d/ && \
    echo 'options lockd nlm_udpport=32768 nlm_tcpport=32768' >> /etc/modprobe.d/local.conf

VOLUME /exports

EXPOSE 111/udp 2049/tcp 32765-32769/tcp 32765-32769/udp

ENTRYPOINT ["/usr/local/bin/nfs_setup"]
