FROM development-base
MAINTAINER Karl Stenerud <kstenerud@gmail.com>

RUN curl -o /tmp/slack.deb https://downloads.slack-edge.com/linux_releases/slack-desktop-2.9.0-amd64.deb && \
	dpkg -i /tmp/slack.deb && \
	rm /tmp/slack.deb
