FROM ubuntu:17.10
MAINTAINER Karl Stenerud <kstenerud@gmail.com>

# This image should be run with --init. Otherwise prepare for zombies.


# =============
# Initial Setup
# =============

RUN apt update -y && apt upgrade -y && apt autoremove
RUN apt install -y locales debconf

# Format <language> <region> <keyboard layout> <keyboard model>
# "en US us pc105" generates LANG en_US.UTF-8, with "us" keyboard model "pc105"
ARG LANG_KB="en US us pc105"

COPY fs/usr/sbin/set_lang_kb.sh /usr/sbin/
RUN /usr/sbin/set_lang_kb.sh $LANG_KB


# =================
# Main Installation
# =================

ARG XRDP_VERSION=v0.9.5
ARG XORGXRDP_VERSION=v0.2.5

# Desktop Environment
RUN apt install -y lubuntu-desktop && \
    apt remove -y light-locker

# Other common software
RUN apt install -y openssh-server openvpn gvfs-bin net-tools telnet less vim curl \
                   apt-transport-https zip unzip wget file build-essential git

RUN apt install -y libx11-dev libxfixes-dev libssl-dev libpam0g-dev libtool libjpeg-dev flex bison gettext autoconf libxml-parser-perl libfuse-dev xsltproc libxrandr-dev python-libxml2 nasm xserver-xorg-dev fuse pkg-config

RUN apt install libglu1-mesa x11-apps x11-session-utils xbitmaps xfonts-scalable xinit xinput xorg xorg-docs-core

RUN git clone https://github.com/neutrinolabs/xrdp.git && \
    cd xrdp && \
    git checkout ${XRDP_VERSION} && \
    ./bootstrap && \
    ./configure --prefix=/usr --enable-fuse --enable-jpeg && \
    make && \
    make install && \
    cd .. && \
    rm -rf xrdp

RUN git clone https://github.com/neutrinolabs/xorgxrdp.git && \
    cd xorgxrdp && \
    git checkout ${XORGXRDP_VERSION} && \
    ./bootstrap && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    cd .. && \
    rm -rf xorgxrdp

COPY fs/ /


# ====
# User
# ====

ARG USER=karl
ARG PASSWORD=$USER

RUN addgroup tsusers
RUN useradd --create-home --shell /bin/bash --user-group --groups adm,sudo,tsusers $USER
RUN echo "$USER:$PASSWORD" | chpasswd


# ===================
# Final Configuration
# ===================

# Xrfb stuff
RUN sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/X11/Xwrapper.config && \
    apt install -y xserver-xorg-core

RUN systemctl enable xrdp.service && \
    systemctl enable xrdp-sesman.service

# Disable SSH DNS lookup becase it slows down SSH login terribly.
RUN sed -i 's/UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config

# Hack to load LXDE by default if .xsession doesn't exist
RUN sed -i 's/^fi$/else\n  lxsession -s Lubuntu -e LXDE\nfi/g' /etc/X11/Xsession.d/40x11-common_xsessionrc

EXPOSE 3389
EXPOSE 22

CMD ["/usr/sbin/ssupervisor.sh"]
