FROM amazonlinux:2017.03 
LABEL authors="Bubba Hines <bubba@stechstudio.com>"
LABEL vendor="Signature Tech Studio, Inc."
LABEL home="https://github.com/stechstudio/aws-lambda-build"

WORKDIR /root




# Install some core packages for building software
RUN yum update -y \
    && yum makecache fast \
    && yum install -y \
        jq \
        zsh \
        wget \
        fuse \
        cmake \
        gtk-doc \
        texlive \
        gmp-devel \
        libssh2-devel \
        libmount-devel \
        dockbook-utils-pdf \
    && yum groupinstall -y "Development Tools"  --setopt=group_package_types=mandatory,default \
    && yum clean all

# Setup my dotfiles.
RUN /usr/bin/git clone --bare --recurse-submodules -j8 https://github.com/bubba-h57/dotfiles.git /root/.dotfiles \
    && /usr/bin/git --git-dir=/root/.dotfiles/ --work-tree=/root checkout \
    && /usr/bin/git --git-dir=/root/.dotfiles/ --work-tree=/root submodule update --recursive \
    && /usr/bin/git --git-dir=/root/.dotfiles/ --work-tree=/root config status.showUntrackedFiles no

# Setup Python
RUN /var/lang/bin/virtualenv --python /usr/bin/python2.7 --prompt=py2Bubba /root/.config/python/venvs/py2Bubba \
    && /var/lang/bin/virtualenv --python /var/lang/bin/python3.6 --prompt=py3Bubba /root/.config/python/venvs/py3Bubba \
    && /root/.config/python/venvs/py2Bubba/bin/pip install -r /root/.config/python/2.7requirements.txt \
    && /root/.config/python/venvs/py3Bubba/bin/pip install -r /root/.config/python/requirements.txt

# Install neovim
ADD https://github.com/neovim/neovim/releases/download/v0.3.1/nvim.appimage /root
RUN chmod 755 /root/nvim.appimage && /root/nvim.appimage --appimage-extract && ln -s /root/squashfs-root/usr/bin/nvim /usr/local/bin/nvim && /usr/local/bin/nvim +'PlugInstall --sync' +qall &> /dev/null

ENTRYPOINT ["/bin/zsh"]
