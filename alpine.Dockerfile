ARG BASEDEV_VERSION=v0.20.7
ARG KUBECTL_VERSION=v1.26.0
ARG STERN_VERSION=v1.22.0
ARG KUBECTX_VERSION=v0.9.4
ARG KUBENS_VERSION=v0.9.4
ARG HELM_VERSION=v3.10.3

FROM kbuley/binpot:kubectl-${KUBECTL_VERSION} AS kubectl
FROM kbuley/binpot:stern-${STERN_VERSION} AS stern
FROM kbuley/binpot:kubectx-${KUBECTX_VERSION} AS kubectx
FROM kbuley/binpot:kubens-${KUBENS_VERSION} AS kubens
FROM kbuley/binpot:helm-${HELM_VERSION} AS helm

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

# Install Rust
ARG RUST_VERSION=1.66.0
ARG RUSTUP_INIT_VERSION=1.24.3
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH
RUN wget -qO /tmp/rustup-init "https://static.rust-lang.org/rustup/archive/${RUSTUP_INIT_VERSION}/x86_64-unknown-linux-musl/rustup-init" && \
    sha256sum /tmp/rustup-init && \
    echo "bdf022eb7cba403d0285bb62cbc47211f610caec24589a72af70e1e900663be9  /tmp/rustup-init" | sha256sum -c - && \
    chmod +x /tmp/rustup-init && \
    /tmp/rustup-init -y --no-modify-path --profile minimal --default-toolchain ${RUST_VERSION} --default-host x86_64-unknown-linux-musl && \
    rm /tmp/rustup-init && \
    chmod -R a+w ${RUSTUP_HOME} ${CARGO_HOME}

# Install gcc required by Rust
RUN apk add --no-cache gcc && \
    ln -s /usr/bin/gcc /usr/bin/x86_64-linux-musl-gcc
# Install musl-dev required by some Rust tooling
RUN apk add --no-cache musl-dev

# Install Rust tooling
ARG RUST_ANALYZER_VERSION=2023-01-02
RUN wget -qO- "https://github.com/rust-analyzer/rust-analyzer/releases/download/${RUST_ANALYZER_VERSION}/rust-analyzer-$(uname -m)-unknown-linux-musl.gz" | \
    gunzip > /usr/local/bin/rust-analyzer && \
    chmod +x /usr/local/bin/rust-analyzer
RUN rustup component add clippy rustfmt

# Extra binary tools
COPY --from=kubectl --chmod=555 /bin /usr/local/bin/kubectl
COPY --from=stern --chmod=555 /bin /usr/local/bin/stern
COPY --from=kubectx --chmod=555 /bin /usr/local/bin/kubectx
COPY --from=kubectx --chmod=555 /bin /usr/local/bin/kubens
COPY --from=helm --chmod=555 /bin /usr/local/bin/helm

# Shell setup
USER ${BASE_USERNAME}
COPY shell/.zshrc-specific shell/.welcome.sh ~/
RUN mkdir ~/.zfunc && rustup completions zsh > ~/.zfunc/_rustup
