FROM golang:1.16.3-buster@sha256:9d64369fd3c633df71d7465d67d43f63bb31192193e671742fa1c26ebc3a6210 AS helmfile

RUN go get github.com/roboll/helmfile@204f78c8ff6831bc3320fa23fc319cfbe7895b5a

FROM ubuntu:20.04@sha256:cf31af331f38d1d7158470e095b132acd126a7180a54f263d386da88eb681d93

RUN apt update
RUN apt upgrade -y

# curl
RUN apt install -y curl

# helm
ENV HELM_VERSION=v3.5.4
RUN curl -fsSL -o /usr/local/bin/get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod +x /usr/local/bin/get_helm.sh && \
    DESIRED_VERSION=${HELM_VERSION} get_helm.sh

# helmfile
ENV HELMFILE_VERSION=v0.139.0
RUN curl -fsSL -o /usr/local/bin/helmfile https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64 && \
    chmod +x /usr/local/bin/helmfile

COPY --from=helmfile /go/bin/helmfile /usr/local/bin/helmfile

# kustomize
ENV KUSTOMIZE_VERSION=4.1.2
RUN curl -fsSL -o /usr/local/bin/install_kustomize.sh https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh && \
    chmod +x /usr/local/bin/install_kustomize.sh && \
    install_kustomize.sh ${KUSTOMIZE_VERSION} /usr/local/bin/

# checks
RUN curl --version
RUN helm version
RUN helmfile version
RUN kustomize version
