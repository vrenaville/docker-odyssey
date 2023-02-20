FROM debian:bullseye as builder


WORKDIR /tmp/
RUN set -ex \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    curl \
    libpqxx-dev \
    postgresql-server-dev-all \
    ca-certificates \
    libssl-dev \
    && curl -L https://github.com/digitalocean/prometheus-client-c/releases/download/v0.1.3/libprom-dev-0.1.3-Linux.deb -o /tmp/libprom-dev-0.1.3-Linux.deb \
    && dpkg --install /tmp/libprom-dev-0.1.3-Linux.deb \
    && git clone --depth 1 --branch 1.3 http://github.com/yandex/odyssey.git \
    && cd odyssey \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release .. \
    && make \
    && apt-get remove -y  build-essential \
    cmake \
    git \
    libpqxx-dev \
    postgresql-server-dev-all \
    libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

FROM debian:bullseye

RUN set -ex \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    && curl -L https://github.com/digitalocean/prometheus-client-c/releases/download/v0.1.3/libprom-dev-0.1.3-Linux.deb -o /tmp/libprom-dev-0.1.3-Linux.deb \
    && dpkg --install /tmp/libprom-dev-0.1.3-Linux.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /tmp/odyssey/build/sources/odyssey /usr/local/bin/
RUN adduser --disabled-password --gecos '' odyssey
USER odyssey
ENTRYPOINT ["/usr/local/bin/odyssey"]
EXPOSE 5432
