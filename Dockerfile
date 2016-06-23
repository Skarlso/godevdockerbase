FROM alpine
MAINTAINER Gergely Brautigam

# RUN mkdir -p /home/default

# Create User.
RUN adduser -D -h /home/default default default
RUN echo default:password123 | chpasswd
RUN addgroup default root

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
    mercurial libxpm-dev libx11-dev libxt-dev ncurses-dev \
    libsm libice libxt libx11 ncurses \
    py-pip openssh && \
    pip install --upgrade pip

# Installing vim.
RUN apk add --update --virtual build-deps python python-dev ctags build-base \
      make mercurial libxpm-dev libx11-dev libxt-dev ncurses-dev git      && \
    cd /tmp                                                               && \
    git clone https://github.com/vim/vim                                  && \
    cd /tmp/vim                                                           && \
    ./configure --with-features=big                                          \
                #needed for editing text in languages which have many characters
                --enable-multibyte                                           \
                #python interop needed for some of my plugins
                --enable-pythoninterp                                        \
                --with-python-config-dir=/usr/lib/python2.7/config           \
                --disable-gui                                                \
                --disable-netbeans                                           \
                --prefix /usr                                             && \
    make VIMRUNTIMEDIR=/usr/share/vim/vim74                               && \
    make install    

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
