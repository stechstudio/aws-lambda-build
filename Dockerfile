FROM awswift/amazonlinux:0.1
LABEL authors="Bubba Hines <bubba@stechstudio.com>"

# Create amzn-ami-hvm-2016.03.3.x86_64-gp2 container suitable for building Lambda binaries

# Build dependencies
RUN \
  yum groupinstall -y "Development Tools"
