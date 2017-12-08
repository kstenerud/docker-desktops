FROM ubuntu:17.04
MAINTAINER Karl Stenerud <kstenerud@gmail.com>

RUN apt update -y && apt upgrade -y

# Locale & Keyboard
RUN apt install -y locales debconf
RUN locale-gen en_US en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN locale > /etc/default/locale
RUN echo "keyboard-configuration keyboard-configuration/modelcode string pc105\n\
keyboard-configuration keyboard-configuration/layoutcode string us\n" | debconf-set-selections

# Desktop Environment
RUN apt install -y lubuntu-desktop && \
    apt remove -y light-locker

RUN apt install -y software-properties-common && \
    add-apt-repository -y ppa:x2go/stable && \
    apt update && \
    apt install -y x2goserver x2goserver-xsession

RUN apt install -y openssh-server openvpn gvfs-bin xrdp net-tools telnet less vim curl \
                   apt-transport-https network-manager network-manager-openvpn-gnome \
                   zip unzip

RUN sed -i 's/UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config


# Services
COPY ssupervisor.sh /usr/sbin/
RUN mkdir /etc/ssupervisor

RUN update-rc.d rsyslog enable && \
    echo "0 rsyslog" >> /etc/ssupervisor/services && \
    update-rc.d dbus enable && \
    echo "0 dbus" >> /etc/ssupervisor/services && \
    update-rc.d ssh enable && \
    echo "0 ssh" >> /etc/ssupervisor/services && \
    update-rc.d xrdp enable && \
    echo "0 xrdp" >> /etc/ssupervisor/services


# User
RUN addgroup tsusers
RUN useradd --create-home --shell /bin/bash --user-group --groups adm,sudo,tsusers karl
RUN echo "karl:karl" | chpasswd

# Hack to allow .xsession to not exist
RUN sed -i 's/^fi$/else\n  lxsession -s Lubuntu -e LXDE\nfi/g' /etc/X11/Xsession.d/40x11-common_xsessionrc

EXPOSE 3389
EXPOSE 22

ENTRYPOINT ["/usr/sbin/ssupervisor.sh"]
