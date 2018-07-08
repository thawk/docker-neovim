FROM alpine:3.7 AS iconv

RUN apk add --no-cache curl g++ make
RUN curl -SL http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.15.tar.gz | tar -xz
WORKDIR libiconv-1.15
RUN ./configure
RUN make
RUN make install


FROM alpine:3.7

ARG VIM_VERSION=master
ARG LUA_VERSION="5.3"

COPY --from=iconv /usr/local/include /usr/local/include/
COPY --from=iconv /usr/local/lib /usr/local/lib/

RUN apk add --no-cache --virtual .build \
        git \
        gcc \
        libc-dev \
        make \
        gettext \
        ncurses-dev \
 && apk add --no-cache \
        ncurses \
        acl-dev \
        diffutils \
        python3-dev \
        lua${LUA_VERSION}-dev luajit-dev \
 && git -c advice.detachedHead=false \
        clone --quiet --depth 1 --branch "${VIM_VERSION}" \
        https://github.com/vim/vim.git /usr/src/vim \
 && cd /usr/src/vim \
 && ./configure \
        --with-features=huge \
        --enable-python3interp \
        --enable-luainterp --with-luajit \
        --enable-fail-if-missing \
 && make \
 && make install \
 && cd /root \
 && rm -fr /usr/src/vim \
 && apk del --purge .build \
# test
 && vim -es \
        -c 'verbose python3 import platform;print("Python3 v" + platform.python_version())' \
        -c 'verbose lua print(_VERSION)' \
        -c q

WORKDIR /root

ENTRYPOINT ["/usr/local/bin/vim"]
