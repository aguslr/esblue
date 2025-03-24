ARG FEDORA_BASE=ghcr.io/aguslr/blue
ARG FEDORA_VARIANT=vanilla
ARG FEDORA_MAJOR_VERSION=40

FROM ${FEDORA_BASE}${FEDORA_VARIANT}:${FEDORA_MAJOR_VERSION}

WORKDIR /tmp
RUN <<-'EOT' sh
	set -eu

	rpm-ostree install java-11-openjdk

	# Download AutoFirma
	curl -fLs 'https://estaticos.redsara.es/comunes/autofirma/1/8/3/AutoFirma_Linux_Fedora.zip' -O
	echo 'ddd3957a06eb750ced8ff449d84d658897dc6dbc54825ba06d362bb0118fd04a  AutoFirma_Linux_Fedora.zip' | sha256sum --check --status
	unzip AutoFirma_Linux_Fedora.zip

	# Download ConfiguradorFNMT
	case "$(rpm -E %{_arch})" in
		x86_64)
			curl -fLs 'https://descargas.cert.fnmt.es/Linux/configuradorfnmt-4.0.6-0.x86_64.rpm' -O
			echo 'a2c564ddc1f5e87b1c47afc196a7ef1d6b4844e59fc8b15cd828250dc9d43f03  configuradorfnmt-4.0.6-0.x86_64.rpm' | sha256sum --check --status
			;;
	esac

	# Install utils
	rpm-ostree install *.rpm

	rpm-ostree cleanup -m && ostree container commit
EOT
