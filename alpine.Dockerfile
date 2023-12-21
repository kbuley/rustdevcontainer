ARG BASEDEV_VERSION=v0.20.11

FROM kbuley/basedevcontainer:${BASEDEV_VERSION}-alpine
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
  org.opencontainers.image.title="Rust Alpine Dev container" \
  org.opencontainers.image.description="Rust development container for Visual Studio Code Remote Containers development"
USER root
WORKDIR /workspace

SHELL ["/bin/ash", "-o", "pipefail", "-c"]

# Install Rust
ARG RUST_VERSION=1.74.1
ARG RUSTUP_INIT_VERSION=1.26.0
ENV RUSTUP_HOME=/usr/local/rustup 
ENV CARGO_HOME=/usr/local/cargo 
ENV PATH=/usr/local/cargo/bin:$PATH
RUN wget -qO /tmp/rustup-init "https://static.rust-lang.org/rustup/archive/${RUSTUP_INIT_VERSION}/x86_64-unknown-linux-musl/rustup-init" && \
  chmod +x /tmp/rustup-init && \
  /tmp/rustup-init -y --no-modify-path --profile minimal --default-toolchain ${RUST_VERSION} --default-host x86_64-unknown-linux-musl && \
  rm /tmp/rustup-init && \
  chmod -R a+w ${RUSTUP_HOME} ${CARGO_HOME}

# Install gcc required by Rust
# hadolint ignore=DL3018
RUN apk add --no-cache gcc musl-dev && \
  ln -s /usr/bin/gcc /usr/bin/x86_64-linux-musl-gcc

# Install Rust tooling
ARG RUST_ANALYZER_VERSION=2023-12-18
RUN wget -qO- "https://github.com/rust-lang/rust-analyzer/releases/download/${RUST_ANALYZER_VERSION}/rust-analyzer-$(uname -m)-unknown-linux-musl.gz" | \
  gunzip > /usr/local/bin/rust-analyzer && \
  chmod +x /usr/local/bin/rust-analyzer
RUN rustup component add clippy rustfmt

# Shell setup
USER ${BASE_USERNAME}
COPY shell/.zshrc-specific shell/.welcome.sh ~/
RUN mkdir ~/.zfunc && rustup completions zsh > ~/.zfunc/_rustup

