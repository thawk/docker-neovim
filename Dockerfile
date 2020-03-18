# FROM registry.redhat.io/ubi7/ubi:latest
FROM centos:centos7

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/thawk/docker-neovim.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0-rc1"

ENV HOME=/root

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
    llvm-toolset-7-clang-tools-extra \
    global \
    global-ctags \
    the_silver_searcher \
    git \
    subversion \
    perf \
    man \
 && true

RUN true \
 && (curl -sL https://rpm.nodesource.com/setup_10.x | bash -) \
 && (curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo > /etc/yum.repos.d/yarn.repo) \
 && yum install -y nodejs yarn

RUN true \
 && cd $HOME \
 && (curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage > nvim.appimage) \
 && chmod u+x nvim.appimage \
 && ./nvim.appimage --appimage-extract \
 && rm nvim.appimage \
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
    pynvim

ENV PATH="${PATH}:${HOME}/squashfs-root/usr/bin"
WORKDIR /src

ENTRYPOINT ["scl", "enable", "llvm-toolset-7", "nvim"]
