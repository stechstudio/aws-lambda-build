## Overview
The [AWS Lambda Execution Environment and Available Libraries](http://docs.aws.amazon.com/lambda/latest/dg/current-supported-versions.html) documents the current AWS Lambda environment. In order to run native binaries in our Lambda functions, we must ensure they are compiled in a compatible environment.

This Docker image is based on **ami-6869aa05** (a.k.a *amzn-ami-hvm-2016.03.3.x86_64-gp2)* and includes the development tools necessary to build executables.

## Requirments
You are going to need [Docker](https://www.docker.com/) installed. You can find a variety of installation instructions, per operating system, in the [Docker Installation Docs](https://docs.docker.com/installation/#installation). If you haven't used Docker before, take a moment and look through the [Docker User Guide](https://docs.docker.com/userguide/).

## Pull The Docker Repository
`docker pull stechstudio/aws-lambda-build`

## Yum Repositories
The image uses the same Amazon YUM Repositories that the AMI image would use in EC2.

## In the Image
The following libraries are available in the AWS Lambda execution environment, regardless of the supported runtime you use, so you don't need to include them:

 - AWS SDK – AWS SDK for JavaScript version 2.45.0
 - AWS SDK for Python (Boto 3) version 1.4.4, Botocore version 1.5.43
 - Amazon Linux build of java-1.8.0-openjdk for Java.

 ### Development Tools
 - autoconf
 - automake
 - binutils
 - bison
 - byacc
 - crash
 - cscope
 - ctags
 - cvs
 - diffstat
 - doxygen
 - elfutils
 - flex
 - gcc
 - gcc-c++
 - gcc-gfortran
 - gdb
 - gettext
 - git
 - indent
 - intltool
 - kexec-tools
 - latrace
 - libtool
 - ltrace
 - make
 - patch
 - patchutils
 - pkgconfig
 - rcs
 - rpm-build
 - strace
 - subversion
 - swig
 - system-rpm-config
 - systemtap
 - systemtap-runtime
 - texinfo
 - valgrind
