FROM alpine:3.7

ARG LUA_VERSION="5.3"

RUN apk add --no-cache \
    curl \
    g++ \
    git \
    libtool \
    lua${LUA_VERSION} \
    neovim \
    python3 \
    python3-dev \
    the_silver_searcher \
 && pip3 install \
    neovim \
    pipenv

ENV HOME /root
WORKDIR $HOME
VOLUME $HOME

ENTRYPOINT ["/usr/bin/nvim"]
