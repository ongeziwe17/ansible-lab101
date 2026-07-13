FROM ubuntu:24.04

ARG DEVOPS_USER
ARG DEVOPS_PASSWORD

ENV DEBIAN_FRONTEND=noninteractive
ENV DEVOPS_USER=${DEVOPS_USER}
ENV ANSIBLE_CONFIG=/workspace/ansible.cfg

RUN apt-get update \
    && apt-get install -y \
        ansible \
        git \
        openssh-client \
        sshpass \
        sudo \
        python3 \
        iputils-ping \
        vim \
        nano \
        tree \
        iproute2 \
        dnsutils \
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

COPY bin/controller-entrypoint.sh /usr/local/bin/controller-entrypoint.sh
RUN sed -i 's/\r$//' /usr/local/bin/controller-entrypoint.sh \
    && chmod 755 /usr/local/bin/controller-entrypoint.sh

USER ${DEVOPS_USER}
WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/controller-entrypoint.sh"]
CMD ["sleep", "infinity"]
