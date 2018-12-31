FROM amazonlinux:2017.03 
LABEL authors="Bubba Hines <bubba@stechstudio.com>"
LABEL vendor="Signature Tech Studio, Inc."
LABEL home="https://github.com/stechstudio/aws-lambda-build"

WORKDIR /root

# Lambda is based on 2017.03. Lock YUM to that release version.
RUN sed -i 's/releasever=latest/releaserver=2017.03/' /etc/yum.conf
RUN yum makecache

# Tools we need
RUN yum groupinstall -y "Development Tools"  --setopt=group_package_types=mandatory,default
RUN yum install -y  jq \
                    gperf \
                    expect \
                    gtk-doc \
                    texlive \
                    python35 \
                    docbook2X \
                    findutils \
                    python35-pip
RUN yum clean all

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

# Install Ninja and Meson
RUN curl -Ls https://github.com/ninja-build/ninja/releases/download/v1.8.2/ninja-linux.zip >> /tmp/ninja.zip && \
    cd /tmp && unzip /tmp/ninja.zip && \
    cp /tmp/ninja /usr/local/bin && \
    /usr/bin/pip-3.5 install meson

# Install the rust toolchain
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# We need a newer cmake than is available, so lets build it ourselves.
RUN mkdir -p /tmp/cmake && \
    cd /tmp/cmake && \
    curl -Ls  https://github.com/Kitware/CMake/releases/download/v3.13.2/cmake-3.13.2.tar.gz | tar xzC /tmp/cmake --strip-components=1 && \
    ./bootstrap --prefix=/usr/local && \
    make && \
    make install
    
ENTRYPOINT ["/bin/zsh"]
