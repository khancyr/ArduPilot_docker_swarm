FROM python:3.8.0-slim-buster as builder

# Say that we won't anwser question
ENV DEBIAN_FRONTEND noninteractive

### Install minimal build tools and remove cache. Don't do any update
RUN apt-get update && apt-get install --no-install-recommends -y \
    python3-dev \
    python3-pip \
    python3-pygame \
    python3-yaml \
    gcc \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN python3 -m pip install -U mavproxy

COPY entrypoint.sh /bin/entrypoint
ENTRYPOINT ["entrypoint"]
