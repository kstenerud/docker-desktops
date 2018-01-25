FROM ubuntu:17.10
MAINTAINER Karl Stenerud <kstenerud@gmail.com>

# Lubuntu desktop in a Docker image, with RDP and X2go remote desktop access.
#
# Run this image with --init. Otherwise you'll get zombies.
#
# ARGs:
#
# USER: The name of the desktop user to create (default ubuntu)
# PASSWORD: The password to use (default same as the user name)
# LANG_KB: The language and keyboard to set for the locale.
#          Format <language> <region> <keyboard layout> <keyboard model>
#          "en US us pc105" = LANG en_US.UTF-8, with "us" keyboard model "pc105"
# TIMEZONE: What time zone to set.


# =============
# Configuration
# =============

ARG USER=ubuntu
ARG PASSWORD=$USER
ARG LANG_KB="en US us pc105"
ARG TIMEZONE="America/Vancouver"

ARG XRDP_VERSION=v0.9.5
ARG XORGXRDP_VERSION=v0.2.5


# =============
# Initial Setup
# =============

RUN apt update -y && \
    apt upgrade -y && \
    apt autoremove -y && \
    apt install -y locales tzdata debconf software-properties-common

COPY fs/usr/sbin/set-lang-kb.sh /usr/sbin/
RUN /usr/sbin/set-lang-kb.sh $LANG_KB

RUN echo "$TIMEZONE" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

# =================
# Main Installation
# =================

# Desktop Environment
RUN apt install -y lubuntu-desktop && apt remove -y light-locker

# Repositories
RUN add-apt-repository -y ppa:x2go/stable
RUN apt update

# Other common software
RUN apt install -y apt-transport-https \
                   autoconf \
                   bison \
                   build-essential \
                   curl \
                   file \
                   flex \
                   fuse \
                   gettext \
                   git \
                   gvfs-bin \
                   less \
                   libfuse-dev \
                   libglu1-mesa \
                   libjpeg-dev \
                   libpam0g-dev \
                   libssl-dev \
                   libtool \
                   libx11-dev \
                   libxfixes-dev \
                   libxml-parser-perl \
                   libxrandr-dev \
                   nasm \
                   net-tools \
                   openssh-server \
                   openvpn \
                   pkg-config \
                   python-libxml2 \
                   telnet \
                   unzip \
                   vim \
                   wget \
                   x11-apps \
                   x11-session-utils \
                   x2goserver \
                   x2goserver-xsession \
                   xbitmaps \
                   xfonts-scalable \
                   xinit \
                   xinput \
                   xorg \
                   xorg-docs-core \
                   xserver-xorg-core \
                   xserver-xorg-dev \
                   xsltproc \
                   zip

# Xrdp from source
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

# Chrome Remote Desktop
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt install -y ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb
RUN wget -q https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb && \
    apt install -y ./chrome-remote-desktop_current_amd64.deb && \
    rm chrome-remote-desktop_current_amd64.deb

# Don't use COPY directly; it overwrites ownership and permissions!
COPY fs /tmp/docker-to-copy-fs
RUN cp -R /tmp/docker-to-copy-fs/* / && rm -rf /tmp/docker-to-copy-fs


# ====
# User
# ====

RUN desktop-user-add.sh $USER $PASSWORD


# ===================
# Final Configuration
# ===================

# Xrfb stuff
RUN sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/X11/Xwrapper.config
RUN systemctl enable xrdp.service && \
    systemctl enable xrdp-sesman.service

# Chrome Remote Desktop stuff
RUN sed -i "s/\(chrome-remote-desktop.*\)/\1${USER}/g" /etc/group
ENV CHROME_REMOTE_DESKTOP_DEFAULT_DESKTOP_SIZES=1920x1080

# Disable SSH DNS lookup becase it slows down SSH login terribly.
RUN sed -i 's/UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config

# Hack to load LXDE by default if .xsession doesn't exist
RUN sed -i 's/^fi$/else\n  lxsession -s Lubuntu -e LXDE\nfi/g' /etc/X11/Xsession.d/40x11-common_xsessionrc

EXPOSE 3389
EXPOSE 22

CMD ["/usr/sbin/ssupervisor.sh"]
