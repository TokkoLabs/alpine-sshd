FROM alpine:latest

# ssh-keygen -A generates all necessary host keys (rsa, dsa, ecdsa, ed25519) at default location.
RUN apk update

RUN KUBERNETES_VERSION="$(wget -qO- https://storage.googleapis.com/kubernetes-release/release/stable.txt)" && \
    wget https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

RUN apk add openssh \
    && mkdir /root/.ssh \
    && chmod 0700 /root/.ssh \
    && ssh-keygen -A \
    && sed -i s/^#PasswordAuthentication\ yes/PasswordAuthentication\ no/ /etc/ssh/sshd_config \
    && sed -i s/^#ClientAliveInterval\ 0/ClientAliveInterval\ 20/ /etc/ssh/sshd_config \
    && sed -i s/^#ClientAliveCountMax\ 0/ClientAliveCountMax\ 15/ /etc/ssh/sshd_config

RUN apk add tmux screen nano vim

# This image expects AUTHORIZED_KEYS environment variable to contain your ssh public key.

COPY docker-entrypoint.sh /

EXPOSE 22

RUN addgroup -S group && \
    adduser -S user -G group --shell /bin/ash --uid 1000 && \
    echo "user:*" | chpasswd -e

ENTRYPOINT ["/docker-entrypoint.sh"]

# -D in CMD below prevents sshd from becoming a daemon. -e is to log everything to stderr.
CMD ["/usr/sbin/sshd", "-D", "-e"]
