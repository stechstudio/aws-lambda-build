FROM awswift/amazonlinux:0.1
LABEL authors="Bubba Hines <bubba@stechstudio.com>"

# Create amzn-ami-hvm-2016.03.3.x86_64-gp2 container suitable for building Lambda binaries

# Build dependencies
RUN yum makecache fast
RUN rpm --rebuilddb && yum groupinstall -y "Development Tools"  --setopt=group_package_types=mandatory,default
RUN rpm --rebuilddb && yum install -y zlib-devel libxml2-devel libssh2-devel libpng-devel
RUN rpm --rebuilddb && yum install -y gmp-devel ghostscript-devel ImageMagick-devel
RUN rpm --rebuilddb && yum install -y jq nasm cmake
RUN rpm --rebuilddb && yum install -y texlive gtk-doc docbook-utils-pdf

RUN mkdir -p /deps/advc
RUN \
  curl -Ls https://github.com/amadvance/advancecomp/releases/download/v2.0/advancecomp-2.0.tar.gz | tar xzC /deps/advc --strip-components=1 \
  && cd /deps/advc \
  && ./configure && make && make install
RUN rm -rf /deps
