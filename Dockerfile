# FROM registry.redhat.io/ubi7/ubi:latest
FROM centos:centos7

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/thawk/docker-neovim.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0-rc1"

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    centos-release-scl-rh \
 && yum install -y \
    python2-pip \
    python3 \
    python3-pip \
    lua \
    make \
    gcc-g++ \
    gdb \
    llvm-toolset-7-clang-tools-extra \
    global \
    global-ctags \
    the_silver_searcher \
    neovim \
    git \
    subversion \
    perf \
    nodejs \
 && (curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo > /etc/yum.repos.d/yarn.repo) \
 && yum install -y yarn \
 && pip2 install \
    neovim \
    jedi \
    flake8 \
    flake8-docstrings \
    flake8-isort \
    flake8-quotes \
 && pip3 install \
    neovim

WORKDIR /src

ENTRYPOINT ["/usr/bin/nvim"]
