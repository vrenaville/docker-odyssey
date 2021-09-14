FROM debian:bullseye

ENV ODYSSEY_SHA=166766adbd9e0efdc033b853dcde481a120c39953b47fc6d7084bf806ab128de

ADD https://github.com/yandex/odyssey/releases/download/1.1/odyssey.linux-amd64.b7bcb86.tar.gz /usr/local/bin/
RUN cd /usr/local/bin/ && \
    tar xzf odyssey.linux-amd64.b7bcb86.tar.gz && \
    [ $(sha256sum /usr/local/bin/odyssey | cut -f1 -d' ') = ${ODYSSEY_SHA} ]
ENTRYPOINT ["/usr/local/bin/odyssey"]
EXPOSE 5432
