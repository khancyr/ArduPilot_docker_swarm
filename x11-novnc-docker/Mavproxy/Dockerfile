FROM ubuntu:19.04

# Set correct environment variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
	xvfb \
	x11vnc \
	supervisor \
	fluxbox \
	net-tools \
	git-core \
	git \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Change work directory to add novnc files
WORKDIR /root/
RUN cd /root && git clone https://github.com/novnc/noVNC.git --depth 2 --no-single-branch novnc \
    && git clone https://github.com/kanaka/websockify --depth 2 --no-single-branch novnc/utils/websockify \
	&& rm -rf /root/novnc/.git \
	&& rm -rf /root/novnc/utils/websockify/.git

RUN ln -s /root/novnc/vnc_lite.html /root/novnc/index.html 

RUN apt-get update && apt-get install --no-install-recommends -y \
    xterm \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-future \
    python3-lxml \
    python3-yaml \
    python3-matplotlib \
    python3-wxgtk4.0 \
    python3-opencv \
    python3-pygame \
    gcc \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN python3 -m pip install -U pip setuptools
RUN python3 -m pip install -U mavproxy


# Docker's supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set display
ENV DISPLAY :1
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV SCREEN_RESOLUTION 1024x768

# Expose Port (Note: if you change it do it as well in surpervisord.conf)
EXPOSE 8083

CMD ["/usr/bin/supervisord"]
