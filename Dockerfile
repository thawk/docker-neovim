# FROM registry.redhat.io/ubi7/ubi:latest
FROM centos:centos7

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/thawk/docker-neovim.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0-rc1"

ENV HOME=/myhome
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN mkdir -p $HOME

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    centos-release-scl-rh \
 && yum install -y \
    python2-pip \
    python3 \
    python3-pip \
    lua \
    make \
    libtool \
    autoconf \
    automake \
    cmake \
    gcc-c++ \
    gdb \
    strace \
    llvm-toolset-7-clang \
    llvm-toolset-7-clang-tools-extra \
    global \
    global-ctags \
    the_silver_searcher \
    git \
    subversion \
    perf \
    man \
    wget \
    fuse-sshfs \
    modprobe fuse \
 && true

RUN pip2 install --upgrade pip \
 && pip3 install --upgrade pip

RUN pip2 install \
    pynvim \
    jedi \
    flake8 \
    flake8-docstrings \
    flake8-isort \
    flake8-quotes \
 && pip3 install \
    msgpack \
    pynvim

RUN true \
 && cd $HOME \
 && (curl -sL https://rpm.nodesource.com/setup_10.x | bash -) \
 && (curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo > /etc/yum.repos.d/yarn.repo) \
 && yum install -y nodejs yarn \
 && npm install -g \
    neovim \
 && true

RUN true \
 && cd $HOME \
 && umask 0000 \
 && (curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage > nvim.appimage) \
 && chmod a+x nvim.appimage \
 && ./nvim.appimage --appimage-extract \
 && rm nvim.appimage \
 && true
#&& find ./squashfs-root -type d | xargs chmod a+rx \

COPY run_nvim.sh ${HOME}
RUN true \
 && ln -s "${HOME}/squashfs-root/usr/bin/nvim" /usr/bin \
 && chmod a+x ${HOME}/run_nvim.sh \
 && true

ENV PATH="${PATH}:${HOME}/node_modules/.bin"
# ENV PATH="${PATH}:${HOME}/squashfs-root/usr/bin"
WORKDIR /src

ENTRYPOINT ["/myhome/run_nvim.sh"]
