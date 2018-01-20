FROM base-desktop
MAINTAINER Karl Stenerud <kstenerud@gmail.com>

RUN dpkg --add-architecture i386 && \
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - && \
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list && \
    apt-get update -y

RUN curl -o /tmp/gitkraken.deb https://release.gitkraken.com/linux/gitkraken-amd64.deb && \
	dpkg -i /tmp/gitkraken.deb && \
	rm /tmp/gitkraken.deb

RUN apt install -y libncurses5:i386 libstdc++6:i386 zlib1g:i386 lib32gcc1 lib32ncurses5 lib32z1 autoconf automake libtool
RUN apt install -y monodevelop python-pip gradle thrift-compiler
RUN apt install -y netbeans meld visualvm git-cola sublime-text

# Protobuf
RUN wget -qO - https://github.com/google/protobuf/archive/v3.5.0.1.tar.gz | tar xz && \
    cd protobuf-3.5.0.1 && \
    ./autogen.sh && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    cd .. && \
    rm -rf protobuf-3.5.0.1

# Go
RUN add-apt-repository ppa:gophers/archive && \
    apt-get update -y && \
    apt install -y golang-1.9-go

# Rust (latest)
RUN curl -o /tmp/rustup.sh https://sh.rustup.rs -sSf && \
    chmod a+x /tmp/rustup.sh && \
    /tmp/rustup.sh -y && \
    rm /tmp/rustup.sh

# Kotlin (latest)
RUN curl -o /tmp/kotlin.sh https://get.sdkman.io -sSf && \
    chmod a+x /tmp/kotlin.sh && \
    mkdir /opt/kotlin && \
    SDKMAN_DIR=/opt/kotlin /tmp/kotlin.sh && \
    rm /tmp/kotlin.sh

