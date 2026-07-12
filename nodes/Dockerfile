ARG UBUNTU_VERSION=22.04

FROM ubuntu:${UBUNTU_VERSION}

ARG DEVOPS_USER
ARG DEVOPS_PASSWORD

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y \
        openssh-server \
        sudo \
        python3 \
        ca-certificates \
        iproute2 \
        iputils-ping \
        procps \
    && rm -rf /var/lib/apt/lists/*

# Create managed-node user and configure password
RUN useradd \
        --create-home \
        --shell /bin/bash \
        "${DEVOPS_USER}" \
    && echo "${DEVOPS_USER}:${DEVOPS_PASSWORD}" | chpasswd

# Explicitly grant sudo access for Ansible become
RUN echo "${DEVOPS_USER} ALL=(ALL:ALL) ALL" \
        > "/etc/sudoers.d/${DEVOPS_USER}" \
    && chmod 440 "/etc/sudoers.d/${DEVOPS_USER}"

# Prepare SSH runtime and user SSH directory
RUN mkdir -p /run/sshd \
    && mkdir -p "/home/${DEVOPS_USER}/.ssh" \
    && chmod 700 "/home/${DEVOPS_USER}/.ssh" \
    && chown -R \
        "${DEVOPS_USER}:${DEVOPS_USER}" \
        "/home/${DEVOPS_USER}/.ssh"

# Configure SSH for the lab
RUN printf '%s\n' \
        'PasswordAuthentication yes' \
        'PermitRootLogin no' \
        > /etc/ssh/sshd_config.d/99-ansible-lab.conf

EXPOSE 22

CMD ["bash", "-c", "ssh-keygen -A && exec /usr/sbin/sshd -D -e"]
