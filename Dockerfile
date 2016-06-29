FROM ubuntu:latest
MAINTAINER Gergely Brautigam

# Create User.
RUN adduser -D -h /home/default default default
RUN echo default:password123 | chpasswd
RUN addgroup default wheel

# Installing utils.
RUN apt-get update && apt-get install -y htop vim git wget mc nmap \
    build-essential cmake python-dev ctags language-pack-en


# Configure VIM.
RUN git clone https://github.com/VundleVim/Vundle.vim.git /home/default/.vim/bundle/Vundle.vim &&
    mkdir -p /home/default/.vim/colors
COPY ./data/.vimrc /home/default/
COPY ./data/onedark.vim /home/default/.vim/colors/
RUN vim +PluginInstall +qall >home/default/vim.out || true
RUN /home/default/.vim/bundle/YouCompleteMe/install.py || true

# Installing Go.
USER default
RUN mkdir /home/default/gohome && mkdir /home/default/gohome/src && \
    mkdir /home/default/gohome/bin && mkdir /home/default/gohome/pkg && \
    wget https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz -O /home/default/go.tar.gz && \

USER root
RUN tar -C /usr/local -xzf /home/default/go.tar.gz

USER default

ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=/home/default/gohome
ENV PATH=$PATH:$GOPATH/bin
RUN echo "export PATH=$PATH:/usr/local/go/bin" >> /home/default/.bash_profile && \
    echo "export GOPATH=/home/default/gohome" >> /home/default/.bash_profile && \
    echo "export PATH=$PATH:$GOPATH/bin" >> /home/default/.bash_profile

# Install Atom.
RUN wget https://github.com/atom/atom/releases/download/v1.8.0/atom-amd64.deb -P /hom/default/atom-amd64.deb
USER root
RUN dpkg --install /home/default/atom-amd64.deb

USER default
