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

FROM kbuley/basedevcontainer:${BASEDEV_VERSION}-debian
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
    org.opencontainers.image.title="Rust Debian Dev container" \
    org.opencontainers.image.description="Rust development container for Visual Studio Code Remote Containers development"
USER root
WORKDIR /workspace

# Install Rust for the correct CPU architecture
ARG RUST_VERSION=1.66.0
ARG RUSTUP_INIT_VERSION=1.24.3
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH
RUN arch="$(uname -m)" && \
    case "$arch" in \
    x86_64) rustArch='x86_64-unknown-linux-gnu'; rustupSha256='3dc5ef50861ee18657f9db2eeb7392f9c2a6c95c90ab41e45ab4ca71476b4338' ;; \
    aarch64) rustArch='aarch64-unknown-linux-gnu'; rustupSha256='32a1532f7cef072a667bac53f1a5542c99666c4071af0c9549795bbdb2069ec1' ;; \
    *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac && \
    wget -qO /tmp/rustup-init "https://static.rust-lang.org/rustup/archive/${RUSTUP_INIT_VERSION}/${rustArch}/rustup-init" && \
    echo "${rustupSha256}  /tmp/rustup-init" | sha256sum -c - && \
    chmod +x /tmp/rustup-init && \
    /tmp/rustup-init -y --no-modify-path --profile minimal --default-toolchain ${RUST_VERSION} --default-host ${rustArch} && \
    rm /tmp/rustup-init && \
    chmod -R a+w ${RUSTUP_HOME} ${CARGO_HOME}

# Install:
# - gcc, libc6-dev required by Rust
# - musl-tools required for static binaries
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -y install --no-install-recommends gcc libc6-dev musl-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Rust tooling
ARG RUST_ANALYZER_VERSION=2023-01-02
RUN wget -qO- "https://github.com/rust-analyzer/rust-analyzer/releases/download/${RUST_ANALYZER_VERSION}/rust-analyzer-$(uname -m)-unknown-linux-gnu.gz" | \
    gunzip > /usr/local/bin/rust-analyzer && \
    chmod 500 /usr/local/bin/rust-analyzer
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
