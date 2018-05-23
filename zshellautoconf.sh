#!/bin/env bash
# *************************************************
#
#       Filename: zshellautoconf.sh
#         Author: Shingo
#          Email: gmboomker@gmail.com
#         Create: 2018-03-30 12:06:37
#       Description: -
#
# *************************************************


# os type judge
cd ~
mkdir ~/gitrepo
source /etc/os-release
case $ID in
    ubuntu)
        apt-get update
        apt -y install git tree tar unzip wget zsh silversearcher-ag gcc cmake dstat htop jq multitail shellcheck python3-pip
        apt -y install software-properties-common && add-apt-repository ppa:jonathonf/vim && apt update && apt -y install vim
        pip3 install --upgrade pip || pip install --upgrade pip
        python3 -m pip install ptipython pip-tools jedi autopep8 glances flake8 \
            PrettyPrinter psutil hsize httpie ngxtop icdiff future frozendict
        VIMRUNTIME=$(find /usr/share -type d -name "vim[0-9]*" 2>/dev/nul)
        export VIMRUNTIME
        cd ~/gitrepo && git clone https://github.com/boomker/Myvimrc.git
        cd ./Myvimrc && cp onedark.vim gruvbox.vim solarized8_dark_flat.vim "${VIMRUNTIME}/colors"
        curl -fLo "${VIMRUNTIME}/autoload/plug.vim" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        cp .vimrc ~/
        cd && curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
        ;;
    centos)
        yum -y install yum-utils &&yum -y install https://centos7.iuscommunity.org/ius-release.rpm
        yum -y install centos-release-scl epel-release.noarch
        sed -i -re '/\[epel\]/,/^enabled/{s/(enabled)=[0,1]$/\1=1/g}' /etc/yum.repos.d/epel.repo && yum -y update
        yum -y install git tree tar unzip wget zsh gcc camke the_silver_searcher dstat ncdu htop \
            socat jq multitail mtr shellcheck pv lsof bind-utils

        # Python3
        LatestPy="$(yum search python3|awk -F'[.,-]+' '/^python3[6u,7,7u]/{print $1}' |sort -u |tail -1)"
        LPyV="$(echo "${LatestPy}" |sed 's/[a-zA-Z]//g'|awk 'BEGIN{FS="";OFS="."}{NF++;print $1,$2}')"
        yum -y install ${LatestPy} ||yum -y install python36u
        yum -y install ${LatestPy}-pip ||yum -y install python36u-pip
        yum -y install ${LatestPy}-devel ||yum -y install python36u-devel
        ln -sv "/usr/bin/pip${LPyV}" /usr/bin/pip3 ||ln -sv /usr/bin/pip3.6 /usr/bin/pip3
        ln -sv "/usr/bin/python${LPyV}" /usr/bin/python3 ||ln -sv /usr/bin/python3.6 /usr/bin/python3
        ln -sv "/usr/bin/python${LPyV}-config" /usr/bin/python3-config ||ln -sv /usr/bin/python3.6-config /usr/bin/python3-config
        ln -sv "/usr/lib64/python${LPyV}/config-${LPyV}m-x86_64-linux-gnu" "/usr/lib64/python${LPyV}/config"
        pip install --upgrade pip ||pip3 install --upgrade pip
        pip3 install ptipython pip-tools jedi autopep8 glances flake8 PrettyPrinter psutil hsize \
            httpstat httpie ngxtop icdiff lolcat
        cd && curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash

        # Vim8.x
        yum -y remove vim-filesystem vim-minimal vim-common vim-enhanced
        yum install -y ruby ruby-devel lua lua-devel luajit \
        luajit-devel ctags python27 python27-scldevel tcl-devel \
        perl perl-devel perl-ExtUtils-ParseXS \
        perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
        perl-ExtUtils-Embed gcc-c++ ncurses-devel \
        scl enable bash
        cd ~/gitrepo
        git clone https://github.com/vim/vim.git
        cd ./vim
        ./configure --with-features=huge \
                    --enable-multibyte \
                    --enable-rubyinterp=yes \
                    --enable-pythoninterp=yes \
                    --with-python-config-dir=/usr/lib64/python2.7/config \
                    --enable-python3interp=yes \
                    --with-python3-config-dir="/usr/lib64/python${LPyV}/config" \
                    --enable-perlinterp=yes \
                    --enable-luainterp=yes \
                    --enable-gui=gtk2 \
                    --enable-cscope \
                    --prefix=/usr/local
        VIMRUNTIME=$(find /usr/local -type d -name "vim[0-9]*" 2>/dev/nul)
        make VIMRUNTIMEDIR=${VIMRUNTIME}
        make install
        update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
        update-alternatives --set editor /usr/local/bin/vim
        export VIMRUNTIME
        cd ~/gitrepo && git clone https://github.com/boomker/Myvimrc.git
        git clone https://github.com/lifepillar/vim-solarized8.git
        cp vim-solarized8/colors/* $VIMRUNTIME/colors/
        curl -fLo "${VIMRUNTIME}/autoload/plug.vim" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        cd ./Myvimrc
        tic xterm-256color-italic.terminfo
        mv ~/.vimrc{,.bak} 2>/dev/null
        cp .vimrc ~/
        ;;
    *)
        exit 1
        ;;
esac


# git Myself zshell conf repo:
cd ~/gitrepo
git clone https://github.com/boomker/Myzshrc.git
cd ~/gitrepo/Myzshrc
mv "${HOME}"/.zshrc{,.bak}
cp .zshrc ~/
source ./oh-my-zsh_install.sh
