FROM mcr.microsoft.com/devcontainers/base:trixie
RUN sudo apt-get update && \
    sudo apt-get -y install pipx && \
    pipx ensurepath
RUN pipx install --include-deps ansible-dev-tools