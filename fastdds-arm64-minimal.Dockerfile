FROM arm64v8/ubuntu:focal


WORKDIR /fastdds


# Needed for a dependency that force to set timezone

ENV TZ=Europe/Madrid

#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV DEBIAN_FRONTEND=noninteractive
# Get ubuntu repositories information and install dependencies

RUN apt update

RUN apt install cmake g++ python3-pip wget git -y

RUN apt install libasio-dev libtinyxml2-dev -y

RUN apt install libssl-dev -y

RUN apt install libp11-dev libengine-pkcs11-openssl -y

RUN apt install softhsm2 -y

RUN usermod -a -G softhsm `whoami`

RUN apt install libengine-pkcs11-openssl -y

RUN pip3 install -U colcon-common-extensions vcstool


# Download and build fastdds

COPY ./fastrtps.repos ./fastrtps.repos

RUN mkdir src && vcs import src < fastrtps.repos

RUN colcon build --cmake-args -DBUILD_SHARED_LIBS=OFF


FROM ubuntu:focal

WORKDIR /fastdds

COPY --from=0 /fastdds/install/fastrtps/bin/fast-discovery-server /fastdds/fast-discovery-server

COPY --from=0 /lib/aarch64-linux-gnu/libtinyxml2.so.6 /lib/aarch64-linux-gnu/libtinyxml2.so.6

COPY --from=0 /lib/aarch64-linux-gnu/libssl.so.1.1 /lib/aarch64-linux-gnu/libssl.so.1.1

COPY --from=0 /lib/aarch64-linux-gnu/libcrypto.so.1.1 /lib/aarch64-linux-gnu/libcrypto.so.1.1

COPY ./entrypoint-minimal.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

