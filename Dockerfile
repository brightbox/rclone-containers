FROM alpine:latest

RUN apk add curl unzip gnupg coreutils rsync lz4 bzip2

# Setup the release gpg signing key
COPY nick-craig-wood.asc /install/key.asc
RUN gpg --import /install/key.asc

ARG version=1.48.0

# write the SHA256SUMS file if it passes gpg verification
RUN curl -s https://downloads.rclone.org/v${version}/SHA256SUMS | gpg > /install/SHA256SUMS

# download, verify, unip the rclone zip and install the binary
RUN cd /install && \
       curl -s https://downloads.rclone.org/v${version}/rclone-v${version}-linux-amd64.zip -O && \
       sha256sum --check --ignore-missing SHA256SUMS && \
       unzip *.zip && rm *.zip && \
       install -m 0755 rclone-v*/rclone /usr/bin/rclone && \
       rm -rf /install

