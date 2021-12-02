FROM debian:bullseye as builder

WORKDIR /tmp/
RUN set -ex \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        libpqxx-dev \
        postgresql-server-dev-all \
        libssl-dev \
    && git clone --depth 1 --branch 1.2 git://github.com/yandex/odyssey.git \
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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /tmp/odyssey/build/sources/odyssey /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/odyssey"]
EXPOSE 5432
