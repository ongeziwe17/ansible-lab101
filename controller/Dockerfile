FROM ubuntu:24.04

ARG DEVOPS_USER
ARG DEVOPS_PASSWORD

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y \
        ansible \
        git \
        openssh-client \
        sudo \
        python3 \
        iputils-ping \
        vim \
        nano \
        tree \
    && rm -rf /var/lib/apt/lists/*

# Create DevOps user and configure password
RUN useradd \
        --create-home \
        --shell /bin/bash \
        "${DEVOPS_USER}" \
    && echo "${DEVOPS_USER}:${DEVOPS_PASSWORD}" | chpasswd

# Explicitly grant sudo access
RUN echo "${DEVOPS_USER} ALL=(ALL:ALL) ALL" \
        > "/etc/sudoers.d/${DEVOPS_USER}" \
    && chmod 440 "/etc/sudoers.d/${DEVOPS_USER}"

# Create SSH directory
RUN mkdir -p "/home/${DEVOPS_USER}/.ssh" \
    && chmod 700 "/home/${DEVOPS_USER}/.ssh" \
    && chown -R \
        "${DEVOPS_USER}:${DEVOPS_USER}" \
        "/home/${DEVOPS_USER}/.ssh"

# Create Ansible workspace
RUN mkdir -p /workspace \
    && chown \
        "${DEVOPS_USER}:${DEVOPS_USER}" \
        /workspace

USER ${DEVOPS_USER}

WORKDIR /workspace

CMD ["sleep", "infinity"]
