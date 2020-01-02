FROM ubuntu:18.04 AS builder

# Say that we won't anwser question
ENV DEBIAN_FRONTEND noninteractive

# Make a working directory
WORKDIR /ardupilot

################################################################################
### Install minimal build tools and remove cache. Don't do any update

RUN apt-get update && apt-get install --no-install-recommends -y \
        curl \
        git \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash - \
    && apt-get install --no-install-recommends -y \
    nodejs \
    build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN npm install pm2 -g


RUN source /etc/lsb-release \
    && echo "deb http://download.rethinkdb.com/apt $DISTRIB_CODENAME main" | tee /etc/apt/sources.list.d/rethinkdb.list \
    && wget -qO- https://download.rethinkdb.com/apt/pubkey.gpg | sudo apt-key add - \
    && apt-get update && sudo apt-get install rethinkdb -y \
    && apt-get install redis-server -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://github.com/GCS-uno/gcs_uno_server.git --depth 2 --no-single-branch \
    && cd gcs_uno_server \
    && npm install \
    && npm run build \
    && cp config_templates/RethinkDB/gcs_uno_server.conf /etc/rethinkdb/instances.d/gcs_uno_server.conf \
    && rethinkdb create -d /var/lib/rethinkdb/gcs_uno_server
    && chown -R rethinkdb.rethinkdb /var/lib/rethinkdb/gcs_uno_server


COPY entrypoint.sh /bin/entrypoint
ENTRYPOINT ["entrypoint"]
