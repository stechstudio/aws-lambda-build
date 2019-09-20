FROM amazonlinux:2018.03
LABEL authors="Bubba Hines <bubba@stechstudio.com>"
LABEL vendor="Signature Tech Studio, Inc."
LABEL home="https://github.com/stechstudio/aws-lambda-build"

WORKDIR /root

# Lambda is based on 2017.03. Lock YUM to that release version.
RUN sed -i 's/releasever=latest/releaserver=2018.03/' /etc/yum.conf

RUN yum makecache \
 && yum groupinstall -y "Development Tools"  --setopt=group_package_types=mandatory,default \
 && yum install -y  jq \
                    zsh \
                    wget \
                    fuse \
                    gperf \
                    expect \
                    gtk-doc \
                    texlive \
                    python35 \
                    gmp-devel \
                    docbook2X \
                    findutils \
                    python35-pip \
                    dockbook-utils-pdf \
                    readline-devel \
                    gettext-devel \
                    libicu-devel \
 && yum clean all

# Install Ninja and Meson
RUN curl -Ls https://github.com/ninja-build/ninja/releases/download/v1.9.0/ninja-linux.zip >> /tmp/ninja.zip \
 && cd /tmp && unzip /tmp/ninja.zip \
 && cp /tmp/ninja /usr/local/bin \
 && /usr/bin/pip-3.5 install meson

# Install the rust toolchain
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# We need a newer cmake than is available, so lets build it ourselves.
RUN mkdir -p /tmp/cmake \
 &&  cd /tmp/cmake \
 && curl -Ls  https://github.com/Kitware/CMake/releases/download/v3.15.3/cmake-3.15.3.tar.gz | tar xzC /tmp/cmake --strip-components=1 \
 && ./bootstrap --prefix=/usr/local \
 && make \
 && make install

# Install neovim
ADD https://github.com/neovim/neovim/releases/download/v0.4.2/nvim.appimage /root
RUN chmod 755 /root/nvim.appimage && /root/nvim.appimage --appimage-extract
RUN ln -s /root/squashfs-root/usr/bin/nvim /usr/local/bin/nvim

# Set some sane environment variables for ourselves
ENV \
    PKG_CONFIG="/usr/bin/pkg-config" \
    SOURCEFORGE_MIRROR="netix" \
    PATH="/root/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
    JQ="/usr/bin/jq" \
    CMAKE='/usr/local/bin/cmake' \
    MESON='/usr/local/bin/meson' \
    NINJA='/usr/local/bin/ninja'

ENTRYPOINT ["/bin/zsh"]
