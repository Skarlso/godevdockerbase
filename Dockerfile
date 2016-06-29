FROM ubuntu:latest
MAINTAINER Gergely Brautigam

# Installing utils.
RUN apt-get update && apt-get install -y htop vim git wget mc nmap \
    build-essential cmake python-dev ctags language-pack-en sudo gconf2 gconf-service \
    gconf2 libgtk2.0-dev xdg-utils libnotify4 libnss3 gvfs-bin


# Create User.
RUN adduser default --gecos "" --ingroup root --disabled-password && \
    echo 'default ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    echo 'default:p' | chpasswd

# Configure VIM.
USER default
RUN git clone https://github.com/VundleVim/Vundle.vim.git /home/default/.vim/bundle/Vundle.vim && \
    mkdir -p /home/default/.vim/colors
COPY ./data/.vimrc /home/default/
COPY ./data/onedark.vim /home/default/.vim/colors/
RUN exec > /home/default/vim.txt 2>&1 && vim +PluginInstall +qall || true
RUN /home/default/.vim/bundle/YouCompleteMe/install.py || true

# Installing Go.
RUN mkdir /home/default/gohome && mkdir /home/default/gohome/src && \
    mkdir /home/default/gohome/bin && mkdir /home/default/gohome/pkg && \
    wget https://storage.googleapis.com/golang/go1.6.1.linux-amd64.tar.gz -O /home/default/go.tar.gz

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
RUN wget https://github.com/atom/atom/releases/download/v1.8.0/atom-amd64.deb -O /home/default/atom-amd64.deb
USER root
RUN dpkg --install /home/default/atom-amd64.deb

USER default
