FROM base-development
MAINTAINER Karl Stenerud <kstenerud@gmail.com>

ARG POSTGRESQL_VERSION=9.6

RUN curl -o /tmp/slack.deb https://downloads.slack-edge.com/linux_releases/slack-desktop-2.9.0-amd64.deb && \
	apt install -y /tmp/slack.deb && \
	rm /tmp/slack.deb

RUN apt install -y postgresql-${POSTGRESQL_VERSION}
RUN sed -i 's/^\(local.*\)peer/\1trust/g' /etc/postgresql/${POSTGRESQL_VERSION}/main/pg_hba.conf
RUN echo "postgresql" >> /etc/ssupervisor/services

# Don't use COPY directly; it overwrites ownership and permissions!
COPY fs /tmp/docker-to-copy-fs
RUN cp -R /tmp/docker-to-copy-fs/* / && rm -rf /tmp/docker-to-copy-fs

RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt install -y ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb
RUN wget -q https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb && \
    apt install -y ./chrome-remote-desktop_current_amd64.deb && \
    rm chrome-remote-desktop_current_amd64.deb
RUN sed -i 's/\(chrome-remote-desktop.*\)/\1karl/g' /etc/group
ENV CHROME_REMOTE_DESKTOP_DEFAULT_DESKTOP_SIZES=1920x1080

RUN apt install -y graphviz qiv eog

