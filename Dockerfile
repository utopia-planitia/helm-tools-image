FROM ubuntu:22.04@sha256:590f59cd1a88bebe6293510a76b28a92a28782f483a1ec1f69ccbc716735b796

RUN apt update
RUN apt upgrade -y

# curl git
RUN apt install -y curl git

# helm
ENV HELM_VERSION=v3.14.4
RUN curl -fsSL -o /usr/local/bin/get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod +x /usr/local/bin/get_helm.sh && \
    DESIRED_VERSION=${HELM_VERSION} get_helm.sh

# helmfile
ENV HELMFILE_VERSION=v0.144.0
RUN curl -fsSL -o /usr/local/bin/helmfile https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64 && \
    chmod +x /usr/local/bin/helmfile

# kustomize
ENV KUSTOMIZE_VERSION=5.4.1
RUN curl -fsSL -o /usr/local/bin/install_kustomize.sh https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh && \
    chmod +x /usr/local/bin/install_kustomize.sh && \
    install_kustomize.sh ${KUSTOMIZE_VERSION} /usr/local/bin/

# checks
RUN curl --version
RUN helm version
RUN helmfile version
RUN kustomize version
