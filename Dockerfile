FROM ubuntu:22.04@sha256:f154feaf13b51d16e2b4b5575d69abc808da40c4b80e3a5055aaa4bcc5099d5b

RUN apt update
RUN apt upgrade -y

# curl git
RUN apt install -y curl git

# helm
ENV HELM_VERSION=v3.7.2
RUN curl -fsSL -o /usr/local/bin/get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod +x /usr/local/bin/get_helm.sh && \
    DESIRED_VERSION=${HELM_VERSION} get_helm.sh

# helmfile
ENV HELMFILE_VERSION=v0.142.0
RUN curl -fsSL -o /usr/local/bin/helmfile https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64 && \
    chmod +x /usr/local/bin/helmfile

# kustomize
ENV KUSTOMIZE_VERSION=4.4.1
RUN curl -fsSL -o /usr/local/bin/install_kustomize.sh https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh && \
    chmod +x /usr/local/bin/install_kustomize.sh && \
    install_kustomize.sh ${KUSTOMIZE_VERSION} /usr/local/bin/

# checks
RUN curl --version
RUN helm version
RUN helmfile version
RUN kustomize version
