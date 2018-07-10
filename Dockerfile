FROM alpine:3.7

ARG LUA_VERSION="5.3"

RUN apk update \
 && apk add \
    curl \
    git \
    g++ \
    libtool \
    neovim \
    the_silver_searcher \
    python3 \
    python3-dev \
    lua${LUA_VERSION} \
 && pip3 install neovim pipenv \
 && rm -rf /var/cache/apk/*

ENV HOME /root
WORKDIR $HOME
VOLUME $HOME

ENTRYPOINT ["/usr/bin/nvim"]
