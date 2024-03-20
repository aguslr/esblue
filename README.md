[ESBlue][1]
===========

[![Vanilla](https://github.com/aguslr/esblue/actions/workflows/build-vanilla.yml/badge.svg)](https://github.com/aguslr/esblue/actions/workflows/build-vanilla.yml)
[![Fusion](https://github.com/aguslr/esblue/actions/workflows/build-fusion.yml/badge.svg)](https://github.com/aguslr/esblue/actions/workflows/build-fusion.yml)
[![Rock](https://github.com/aguslr/esblue/actions/workflows/build-rock.yml/badge.svg)](https://github.com/aguslr/esblue/actions/workflows/build-rock.yml)

A custom image based on [BlueVanilla][2]/[BlueFusion][3]/[BlueRock][4] with
packages to use digital certificates with the Spanish government.

![Screenshot](screenshot.png "Screenshot")

Usage
-----

1. Rebase to an unsigned image to get proper signing keys:

       rpm-ostree rebase ostree-unverified-registry:ghcr.io/aguslr/esblue:latest && systemctl reboot

2. Rebase to a signed image to finish the installation:

       rpm-ostree rebase ostree-image-signed:docker://ghcr.io/aguslr/esblue:latest && systemctl reboot

Alternatively, an [ISO file for offline installation][8] can be generated with
the following command:

    sudo podman run --rm --privileged --volume .:/isogenerator/output \
        --security-opt label=disable --pull=newer \
        -e IMAGE_REPO="ghcr.iso/aguslr" -e IMAGE_NAME="esblue" \
        -e IMAGE_TAG="latest" -e VARIANT="Silverblue" \
        ghcr.io/ublue-os/isogenerator:39

Features
--------

- Add the following packages to the image:
  + `java-17-openjdk-headless`
  + [`autofirma-1.8.2-1.noarch_FEDORA.rpm`][5]
  + [`configuradorfnmt-4.0.5-0.x86_64.rpm`][6]

Tags
----

There are three flavors for this image:

- `latest`: Adds packages on top of [BlueVanilla][2].

- `fusion`: Adds packages on top of [BlueFusion][3].

- `rock`: Adds packages on top of [BlueRock][4].

Verification
------------

These images are signed with Sisgstore's [Cosign][7]. You can verify the
signature by downloading the `cosign.pub` key from this repo and running the
following command:

    cosign verify --key cosign.pub ghcr.io/aguslr/esblue


[1]: https://github.com/aguslr/esblue
[2]: https://github.com/aguslr/bluevanilla
[3]: https://github.com/aguslr/bluefusion
[4]: https://github.com/aguslr/bluerock
[5]: https://firmaelectronica.gob.es/Home/Descargas.html
[6]: https://www.sede.fnmt.gob.es/descargas/descarga-software/instalacion-software-generacion-de-claves
[7]: https://docs.sigstore.dev/cosign/overview/
[8]: https://blue-build.org/learn/universal-blue/#fresh-install-from-an-iso
