FROM alpine:3.7

ARG LUA_VERSION="5.3"

RUN apk update \
 && apk add \
    curl \
    git \
    neovim \
    the_silver_searcher \
    python3 \
    lua${LUA_VERSION} \
 && pip3 install neovim pipenv \
 && rm -rf /var/cache/apk/* \

ENV HOME /root
WORKDIR $HOME
VOLUME $HOME

ENTRYPOINT ["/usr/local/bin/nvim"]
