FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

# The user creation process inside the dockerfile came from this article
# https://medium.com/faun/set-current-host-user-for-docker-container-4e521cef9ffc
ARG USER=pydev
ARG PW=pydev
ARG UID=1000
ARG GID=1000

# Adding a new non-root user pydev, use sudo if you need root privileges
# If you don't pass USER and PW arguments, the user you're currently logged in
# will be used
RUN useradd -m ${USER} -u ${UID} && echo "${USER}:${PW}" | chpasswd

# Update packages
RUN apt update && apt-get update && apt -y upgrade && apt-get -y upgrade

# Install essential packages
RUN apt install -y \
  apt-transport-https \
  ca-certificates \ 
  curl \
  git \
  netbase \
  openssl \
  software-properties-common \
  sudo \
  wget \
  && apt-get install -y \
  build-essential \
  libffi-dev \
  libssl-dev

# Python packages
RUN apt install -y \
  python3-dev \
  python3-venv \
  python3-pip \
  python2 \
  virtualenv

# Install python 2 pip
RUN curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py \
  && python2 get-pip.py && rm -rf get-pip.py

# Clean up apt cache
RUN rm -rf /var/lib/apt/lists/*

# Add user to sudo group
RUN adduser ${USER} sudo

# Setup default user when entering docker container
USER ${UID}:${GID}
WORKDIR /home/${USER}

CMD [ "/bin/bash" ]