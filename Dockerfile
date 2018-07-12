FROM alpine:3.7

ARG LUA_VERSION="5.3"
ARG GLOBAL_VER="6.6.2"

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/thawk/docker-neovim.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0-rc1"

RUN apk add --no-cache \
    clang \
    clang-libs \
    ctags \
    curl \
    g++ \
    git \
    libtool \
    make \
    neovim \
    neovim-doc \
    nodejs-npm \
    python3 \
    py3-pygments \
    the_silver_searcher \
 && apk add --no-cache --virtual build-deps \
    autoconf \
    automake \
    bison \
    flex \
    gperf \
    ncurses-dev \
    python3-dev \
    texinfo \
 && pip3 install \
    flake8 \
    flake8-docstrings \
    flake8-isort \
    flake8-quotes \
    jedi \
    neovim \
    pipenv \
 && cd /tmp \
 && curl -fSL http://tamacom.com/global/global-$GLOBAL_VER.tar.gz -o global-$GLOBAL_VER.tar.gz \
 && tar xzf global-$GLOBAL_VER.tar.gz \
 && cd global-$GLOBAL_VER \
 && ./configure --with-exuberant-ctags=/usr/bin/ctags \
 && make \
 && make install \
 && cp /usr/local/share/gtags/gtags.conf /etc/gtags.conf \
 && rm -rf /tmp/global-$GLOBAL_VER /tmp/global-$GLOBAL_VER.tar.gz \
 && apk del build-deps

WORKDIR /src

ENTRYPOINT ["/usr/bin/nvim"]
