FROM base-development
MAINTAINER Karl Stenerud <kstenerud@gmail.com>

ARG POSTGRESQL_VERSION=9.6

RUN curl -o /tmp/slack.deb https://downloads.slack-edge.com/linux_releases/slack-desktop-2.9.0-amd64.deb && \
	apt install -y /tmp/slack.deb && \
	rm /tmp/slack.deb

RUN apt install -y postgresql-${POSTGRESQL_VERSION} && \
    sed -i 's/^\(local.*\)peer/\1trust/g' /etc/postgresql/${POSTGRESQL_VERSION}/main/pg_hba.conf && \
    echo "postgresql" >> /etc/ssupervisor/services

# Don't use COPY directly; it overwrites ownership and permissions!
COPY fs /tmp/docker-to-copy-fs
RUN cp -R /tmp/docker-to-copy-fs/* / && rm -rf /tmp/docker-to-copy-fs

RUN apt install -y graphviz qiv eog
