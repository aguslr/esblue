ARG FEDORA_BASE=ghcr.io/aguslr/blue
ARG FEDORA_VARIANT=vanilla
ARG FEDORA_MAJOR_VERSION=40

FROM ${FEDORA_BASE}${FEDORA_VARIANT}:${FEDORA_MAJOR_VERSION}

RUN cd /tmp && \
    curl -fLs 'https://descargas.cert.fnmt.es/Linux/configuradorfnmt-4.0.5-0.x86_64.rpm' -O && \
    echo 'fd026bb963376969f76fcc408fe87cbea57f07682ce440b1744f1f2cdb2ce43d  configuradorfnmt-4.0.5-0.x86_64.rpm' | sha256sum --check --status && \
    curl -fLs 'https://estaticos.redsara.es/comunes/autofirma/currentversion/AutoFirma_Linux_Fedora.zip' -O && \
    echo '86a3b4673ce78663ab996aa542a2bd93f9e666f04e16f4763cccfba6274beb04  AutoFirma_Linux_Fedora.zip' | sha256sum --check --status && \
    unzip AutoFirma_Linux_Fedora.zip && \
    rpm-ostree install java-17-openjdk && \
    for bin in /usr/lib/jvm/java-17-openjdk*/bin/*; do \
        ln -s "${bin}" /etc/alternatives/ && \
        ln -s /etc/alternatives/"$(basename "${bin}")" /usr/bin/; \
    done && \
    rpm-ostree install autofirma-*.noarch_FEDORA.rpm configuradorfnmt-*.x86_64.rpm ; \
    rpm-ostree cleanup -m && \
    ostree container commit
