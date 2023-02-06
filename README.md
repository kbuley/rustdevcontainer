# Rust Dev Container

Rust development container for Visual Studio Code

![Icon](https://github.com/kbuley/rustdevcontainer/raw/main/icon.svg)

[![Alpine](https://github.com/kbuley/rustdevcontainer/actions/workflows/alpine.yml/badge.svg)](https://github.com/kbuley/rustdevcontainer/actions/workflows/alpine.yml)
[![Debian](https://github.com/kbuley/rustdevcontainer/actions/workflows/debian.yml/badge.svg)](https://github.com/kbuley/rustdevcontainer/actions/workflows/debian.yml)

[![dockeri.co](https://dockeri.co/image/kbuley/rustdevcontainer)](https://hub.docker.com/r/kbuley/rustdevcontainer)

![Last Docker tag](https://img.shields.io/docker/v/kbuley/rustdevcontainer?sort=semver&label=Last%20Docker%20tag)
[![Latest size](https://img.shields.io/docker/image-size/kbuley/rustdevcontainer/latest?label=Latest%20image)](https://hub.docker.com/r/kbuley/rustdevcontainer/tags)

![Last release](https://img.shields.io/github/release/kbuley/rustdevcontainer?label=Last%20release)
[![Last release size](https://img.shields.io/docker/image-size/kbuley/rustdevcontainer?sort=semver&label=Last%20released%20image)](https://hub.docker.com/r/kbuley/rustdevcontainer/tags?page=1&ordering=last_updated)
![GitHub last release date](https://img.shields.io/github/release-date/kbuley/rustdevcontainer?label=Last%20release%20date)
![Commits since release](https://img.shields.io/github/commits-since/kbuley/rustdevcontainer/latest?sort=semver)

[![GitHub last commit](https://img.shields.io/github/last-commit/kbuley/rustdevcontainer.svg)](https://github.com/kbuley/rustdevcontainer/commits/main)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/y/kbuley/rustdevcontainer.svg)](https://github.com/kbuley/rustdevcontainer/graphs/contributors)
[![GitHub closed PRs](https://img.shields.io/github/issues-pr-closed/kbuley/rustdevcontainer.svg)](https://github.com/kbuley/rustdevcontainer/pulls?q=is%3Apr+is%3Aclosed)
[![GitHub issues](https://img.shields.io/github/issues/kbuley/rustdevcontainer.svg)](https://github.com/kbuley/rustdevcontainer/issues)
[![GitHub closed issues](https://img.shields.io/github/issues-closed/kbuley/rustdevcontainer.svg)](https://github.com/kbuley/rustdevcontainer/issues?q=is%3Aissue+is%3Aclosed)

[![Lines of code](https://img.shields.io/tokei/lines/github/kbuley/rustdevcontainer)](https://github.com/kbuley/rustdevcontainer)
![Code size](https://img.shields.io/github/languages/code-size/kbuley/rustdevcontainer)
![GitHub repo size](https://img.shields.io/github/repo-size/kbuley/rustdevcontainer)

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=rustdevcontainer.readme)

## Features

- Rust 1.66.0
- Rust Analyzer 2023-01-02
- Clippy
- Rustfmt
- Alpine based with Docker tags `:latest` and `:alpine`
  - 1.16GB amd64 uncompressed image size
  - Compatible with `amd64`
  - Based on [kbuley/basedevcontainer:alpine](https://github.com/kbuley/basedevcontainer)
    - Based on Alpine 3.16
    - Minimal custom terminal and packages
    - See more [features](https://github.com/kbuley/basedevcontainer#features)
- Debian based with Docker tag `:debian` (1.51GB, based on [kbuley/basedevcontainer:debian](https://github.com/kbuley/basedevcontainer))
  - 1.21GB amd64 uncompressed image size
  - Compatible with `amd64` and `arm64`
  - Based on [kbuley/basedevcontainer:debian](https://github.com/kbuley/basedevcontainer)
    - Based on Debian Buster slim
    - Minimal custom terminal and packages
    - See more [features](https://github.com/kbuley/basedevcontainer#features)
- Cross platform
  - Easily bind mount your SSH keys to use with **git**
  - Manage your host Docker from within the dev container, more details at [kbuley/basedevcontainer](https://github.com/kbuley/basedevcontainer#features)
- Extensible with docker-compose.yml
- Comes with extra binary tools for a few extra MBs: `kubectl`, `kubectx`, `kubens`, `stern` and `helm`

## Requirements

See [.devcontainer/README.md#Requirements](.devcontainer/README.md#Requirements)

## Setup for a project

1. Setup your configuration files
    - With style 💯

        ```sh
        docker run -it --rm -v "/yourrepopath:/repository" kbuley/devtainr:v0.2.0 -dev rust -path /repository -name projectname
        ```

        Or use the [built binary](https://github.com/kbuley/devtainr#binary)
    - Or manually: download this repository and put the [.devcontainer](.devcontainer) directory in your project.
1. If you have a *.vscode/settings.json*, eventually move the settings to *.devcontainer/devcontainer.json* in the `"settings"` section as *.vscode/settings.json* take precedence over the settings defined in *.devcontainer/devcontainer.json*.
1. Open the command palette in Visual Studio Code (CTRL+SHIFT+P) and select `Remote-Containers: Open Folder in Container...` and choose your project directory
1. See [.devcontainer/README.md#Setup](.devcontainer/README.md#Setup)

## Customization

See [.devcontainer/README.md#Customization](.devcontainer/README.md#Customization)

## License

This repository is under an [MIT license](https://github.com/kbuley/rustdevcontainer/main/LICENSE) unless indicated otherwise.
