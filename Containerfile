ARG FEDORA_BASE=ghcr.io/aguslr/blue
ARG FEDORA_VARIANT=vanilla
ARG FEDORA_MAJOR_VERSION=40

FROM quay.io/fedora/fedora:latest AS builder

WORKDIR /tmp
RUN <<-'EOT' sh
	set -u

	dnf install -y rpm-build cpio --setopt=install_weak_deps=False

	# Download AutoFirma
	curl -fLs 'https://estaticos.redsara.es/comunes/autofirma/1/8/3/AutoFirma_Linux_Fedora.zip' -O
	echo '8fcc7f7d3101ae313ac739bd8c640631cff5717d981f165b471a72e0e52b8a74  AutoFirma_Linux_Fedora.zip' | sha256sum --check --status
	unzip AutoFirma_Linux_Fedora.zip

	# Download ConfiguradorFNMT
	curl -fLs 'https://descargas.cert.fnmt.es/Linux/configuradorfnmt-4.0.6-0.x86_64.rpm' -O
	echo 'a2c564ddc1f5e87b1c47afc196a7ef1d6b4844e59fc8b15cd828250dc9d43f03  configuradorfnmt-4.0.6-0.x86_64.rpm' | sha256sum --check --status

	rpm2cpio configuradorfnmt-*.x86_64.rpm | cpio -dium -D src

	rm -rf src/usr/lib64/configuradorfnmt/jre
	sed -i 's|^Exec=.*$|Exec=java -classpath /usr/lib64/configuradorfnmt/configuradorfnmt.jar:bcpkix-fips.jar:bc-fips.jar es.gob.fnmt.cert.certrequest.CertRequest %u|' src/usr/share/applications/configuradorfnmt.desktop
	printf '#!/usr/bin/env sh\njava -classpath /usr/lib64/configuradorfnmt/configuradorfnmt.jar:bcpkix-fips.jar:bc-fips.jar es.gob.fnmt.cert.certrequest.CertRequest "$@"\n' > src/usr/bin/configuradorfnmt

	rpm -qpi configuradorfnmt-*.x86_64.rpm > rpm.spec
	sed -i -e '/^Architecture/d' -e '/^Install Date/d' -e '/^Size/d' -e '/^Signature/d' -e '/^Build /d' -e '/^Description/,+1d' rpm.spec
	printf 'BuildArch   : noarch\nBuildRoot   : %s/src\n\n%%description\n%s\n\n%%files\n' "${PWD}" 'Utilidad FNMT para la solicitud e instalación de certificados desde la página web de FNMT-RCM.' >> rpm.spec
	find "${PWD}/src" -type f -printf '/%P\n' >> rpm.spec

	rpmbuild --define "_topdir ${PWD}/rpmbuild" --buildroot="${PWD}/src" -bb rpm.spec
	rm -f configuradorfnmt-*.x86_64.rpm
EOT

FROM ${FEDORA_BASE}${FEDORA_VARIANT}:${FEDORA_MAJOR_VERSION}

COPY --from=builder /tmp/*.rpm /tmp
COPY --from=builder /tmp/rpmbuild/RPMS/noarch/*.rpm /tmp

WORKDIR /tmp
RUN <<-'EOT' sh
	set -eu

	rpm-ostree install java

	# Install utils
	rpm-ostree install *.rpm

	if [ "$(rpm -E %{fedora})" != '41' ]; then
		for bin in /usr/lib/jvm/java-*-openjdk*/bin/*; do
			ln -s "${bin}" /etc/alternatives/
			ln -s /etc/alternatives/"$(basename "${bin}")" /usr/bin/
		done
	fi

	rpm-ostree cleanup -m && ostree container commit
EOT
