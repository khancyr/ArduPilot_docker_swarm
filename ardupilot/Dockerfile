FROM alpine:3.10 AS builder

# Make a working directory
WORKDIR /ardupilot

################################################################################
### Install minimal build tools and remove cache. Don't do any update

RUN apk update && apk add --no-cache linux-headers \
        g++ \
        python \
	    py-lxml \
	    py-pip \
        py-future \
        git \
        &&  rm -rf /var/cache/apk/*

# Clone simplified. Don't clone all the tree and nuttx stuff on 3.6 branch
RUN git clone https://github.com/ArduPilot/ardupilot.git --depth 2 --no-single-branch src \
    && cd src \
    && git checkout master \
    && git submodule update --init --recursive modules/gbenchmark \
    && git submodule update --init --recursive modules/gtest \
    && git submodule update --init --recursive modules/mavlink \
    && git submodule update --init --recursive modules/uavcan \
    && git submodule update --init --recursive modules/waf

# Build binary
RUN cd /ardupilot/src && ./waf configure --board sitl --no-submodule-update \
    && ./waf copter

# Second stage build
FROM alpine:3.10

WORKDIR /ardupilot

RUN apk add --no-cache libstdc++

# Copy binary and defaut param file from previous image
COPY --from=builder /ardupilot/src/build/sitl/bin/arducopter .
COPY --from=builder /ardupilot/src/Tools/autotest/default_params/copter.parm .

################################################################################
#### Setup the entrypoint == application that will launch by default

COPY entrypoint.sh /bin/entrypoint
ENTRYPOINT ["entrypoint"]
