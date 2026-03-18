FROM mcr.microsoft.com/devcontainers/base:trixie
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.35/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
RUN sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
RUN echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.35/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
RUN sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
RUN sudo apt-get update && sudo apt-get install -y kubectl
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
RUN sudo apt update && sudo apt install -y terraform
RUN sudo apt-get update && \
    sudo apt-get -y install pipx && \
    pipx ensurepath
RUN pipx install --include-deps ansible-core==2.18.14
RUN pipx inject ansible-core ansible-lint
RUN pipx inject ansible-core pydo
RUN pipx inject ansible-core netaddr