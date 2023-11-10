ARG FEDORA_BASE=vanilla
ARG FEDORA_MAJOR_VERSION=39

FROM ghcr.io/aguslr/blue${FEDORA_BASE}:${FEDORA_MAJOR_VERSION}

RUN rpm-ostree install java-1.8.0-openjdk && cd /tmp && \
    curl -fLs 'https://descargas.cert.fnmt.es/Linux/configuradorfnmt-4.0.2-0.x86_64.rpm' -O && \
    echo '34395c27b7713bf358da3f3f472b9e0a19c94bef9bb796c6582bffb61bfab3e2  configuradorfnmt-4.0.2-0.x86_64.rpm' | sha256sum --check --status && \
    curl -fLs 'https://estaticos.redsara.es/comunes/autofirma/currentversion/AutoFirma_Linux_Fedora.zip' -O && \
    echo '86a3b4673ce78663ab996aa542a2bd93f9e666f04e16f4763cccfba6274beb04  AutoFirma_Linux_Fedora.zip' | sha256sum --check --status && \
    unzip AutoFirma_Linux_Fedora.zip && \
    rpm-ostree install autofirma-*.noarch_FEDORA.rpm configuradorfnmt-*.x86_64.rpm && \
    ostree container commit
