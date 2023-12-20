ARG BASEDEV_VERSION=v0.20.9

FROM kbuley/basedevcontainer:${BASEDEV_VERSION}-ubuntu
ARG CREATED
ARG COMMIT
ARG VERSION=local
LABEL \
  org.opencontainers.image.authors="kevin@buley.org" \
  org.opencontainers.image.created=$CREATED \
  org.opencontainers.image.version=$VERSION \
  org.opencontainers.image.revision=$COMMIT \
  org.opencontainers.image.url="https://github.com/kbuley/rustdevcontainer" \
  org.opencontainers.image.documentation="https://github.com/kbuley/rustdevcontainer" \
  org.opencontainers.image.source="https://github.com/kbuley/rustdevcontainer" \
  org.opencontainers.image.title="Rust Ubuntu Dev container" \
  org.opencontainers.image.description="Rust development container for Visual Studio Code Remote Containers development"
USER root
WORKDIR /workspace

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install Rust for the correct CPU architecture
ARG RUST_VERSION=1.74.1
ARG RUSTUP_INIT_VERSION=1.26.0
ENV RUSTUP_HOME=/usr/local/rustup \
  CARGO_HOME=/usr/local/cargo \
  PATH=/usr/local/cargo/bin:$PATH
RUN arch="$(uname -m)" && \
  case "$arch" in \
  x86_64) rustArch='x86_64-unknown-linux-gnu' ;; \
  aarch64) rustArch='aarch64-unknown-linux-gnu' ;; \
  *) echo >&2 "unsupported architecture: ${arch}"; exit 1 ;; \
  esac && \
  wget -qO /tmp/rustup-init "https://static.rust-lang.org/rustup/archive/${RUSTUP_INIT_VERSION}/${rustArch}/rustup-init" && \
  chmod +x /tmp/rustup-init && \
  /tmp/rustup-init -y --no-modify-path --profile minimal --default-toolchain "${RUST_VERSION}" --default-host "${rustArch}" && \
  rm /tmp/rustup-init && \
  chmod -R a+w "${RUSTUP_HOME}" "${CARGO_HOME}"

# Install:
# - gcc, libc6-dev required by Rust
# - musl-tools required for static binaries
# hadolint ignore=DL3008
RUN export UBUNTU_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get -y install --no-install-recommends gcc libc6-dev musl-tools && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Rust tooling
ARG RUST_ANALYZER_VERSION=2023-12-18
RUN wget -qO- "https://github.com/rust-analyzer/rust-analyzer/releases/download/${RUST_ANALYZER_VERSION}/rust-analyzer-$(uname -m)-unknown-linux-gnu.gz" | \
  gunzip > /usr/local/bin/rust-analyzer && \
  chmod 500 /usr/local/bin/rust-analyzer
RUN rustup component add clippy rustfmt

# Shell setup
USER ${BASE_USERNAME}
COPY shell/.zshrc-specific shell/.welcome.sh ~/
RUN mkdir ~/.zfunc && rustup completions zsh > ~/.zfunc/_rustup
