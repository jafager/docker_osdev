# Start from CentOS 7 with the latest updates
FROM centos:7
RUN yum -y -q update


# Install basic compiler tools
RUN yum -y -q install gcc make file automake autoconf libtool gcc-c++


# Create a temporary build directory
RUN mkdir /root/build
WORKDIR /root/build


# Compile and install target binutils
COPY binutils-2.29.1.tar.gz .
RUN tar xfz binutils-2.29.1.tar.gz
RUN mkdir binutils-build
WORKDIR binutils-build
RUN ../binutils-2.29.1/configure --prefix=/usr/local --target=x86_64-elf
RUN make -j 4
RUN make install
WORKDIR /root/build


# Compile and install target GCC
RUN yum -y -q install gmp-devel mpfr-devel libmpc-devel
COPY gcc-7.2.0.tar.gz .
RUN tar xfz gcc-7.2.0.tar.gz
RUN mkdir gcc-build
WORKDIR gcc-build
RUN ../gcc-7.2.0/configure --prefix=/usr/local --target=x86_64-elf --enable-languages=c --without-headers
RUN make -j 4 all-gcc
RUN make -j 4 all-target-libgcc
RUN make install-gcc
RUN make install-target-libgcc
WORKDIR /root/build


# Compile and install NASM
COPY nasm-2.13.01.tar.gz .
RUN tar xfz nasm-2.13.01.tar.gz
WORKDIR nasm-2.13.01
RUN ./configure --prefix=/usr/local
RUN make -j 4
RUN make install
WORKDIR /root/build


# Compile and install QEMU
RUN yum -y -q install zlib-devel glib2-devel
COPY qemu-2.10.1.tar.xz .
RUN xz -dc qemu-2.10.1.tar.xz | tar xf -
WORKDIR qemu-2.10.1
RUN ./configure --prefix=/usr/local --target-list=x86_64-softmmu
RUN make -j 4
RUN make install
WORKDIR /root/build


# Compile and install Xorisso
COPY xorriso-1.4.8.tar.gz .
RUN tar xfz xorriso-1.4.8.tar.gz
WORKDIR xorriso-1.4.8
RUN ./configure --prefix=/usr/local
RUN make -j 4
RUN make install
WORKDIR /root/build


# Remove temporary build directory
WORKDIR /
RUN rm -fr /root/build


# Install developer tools for interactive use
RUN yum -y -q install git grub2 grub2-tools vim telnet net-tools


# Create osdev user and populate home directory
RUN useradd -M osdev
RUN mkdir /home/osdev
RUN chmod 700 /home/osdev
COPY home_osdev /home/osdev
RUN chown -R osdev:osdev /home/osdev


# Install fancy prompt script
COPY abbreviate_cwd /usr/local/bin
RUN chmod 755 /usr/local/bin/abbreviate_cwd


# Connections to the outside world
EXPOSE 5900
VOLUME /home/osdev


# Container starts with bash login shell for osdev user
USER osdev
WORKDIR /home/osdev
CMD bash --login
