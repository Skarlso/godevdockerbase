FROM alpine
MAINTAINER Gergely Brautigam

# RUN mkdir -p /home/default

# Create User.
RUN adduser -D -h /home/default default default

# Setup Alpine.
COPY ./data/repositories /etc/apk/
COPY ./data/.bash_profile /home/default/
RUN chown default:default /home/default/.bash_profile

# Install essential software.
RUN apk upgrade && apk update && apk add --no-cache python python-dev ctags \
    bash bash-doc bash-completion \
    util-linux pciutils usbutils coreutils binutils findutils grep \
    udisks2 udisks2-doc \
    build-base gcc abuild binutils binutils-doc gcc-doc \
    man man-pages \
    htop git wget mc nmap lynx curl mercurial bzr \
    cmake cmake-doc extra-cmake-modules extra-cmake-modules-doc \
    make \
    perl shadow ncurses \
    iptables \
    py-pip openssh && \
    pip install --upgrade pip

RUN apk add vim

USER default

# Configure VIM.
RUN git clone https://github.com/VundleVim/Vundle.vim.git /home/default/.vim/bundle/Vundle.vim
RUN mkdir -p /home/default/.vim/colors
COPY ./data/.vimrc /home/default/
COPY ./data/onedark.vim /home/default/.vim/colors/
RUN vim +PluginInstall +qall >home/default/vim.out || true
RUN /home/default/.vim/bundle/YouCompleteMe/install.py || true

# Install Go.
RUN mkdir /home/default/gohome && \
    mkdir /home/default/gohome/src && \
    mkdir /home/default/gohome/bin && \
    mkdir /home/default/gohome/pkg

USER root
RUN apk add --no-cache go

USER default
ENV GOROOT=/usr/lib/go
ENV PATH=$PATH:$GOROOT/bin
ENV GOPATH=/home/default/gohome
ENV PATH=$PATH:$GOPATH/bin
