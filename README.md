[ESBlue][1]
===========

[![Vanilla](https://github.com/aguslr/esblue/actions/workflows/build-vanilla.yml/badge.svg)](https://github.com/aguslr/esblue/actions/workflows/build-vanilla.yml)
[![Fusion](https://github.com/aguslr/esblue/actions/workflows/build-fusion.yml/badge.svg)](https://github.com/aguslr/esblue/actions/workflows/build-fusion.yml)

A custom image based on [BlueVanilla][2] and [BlueFusion][3] with packages to
use digital certificates with the Spanish government.

![Screenshot](screenshot.png "Screenshot")

Usage
-----

    sudo rpm-ostree rebase --experimental ostree-unverified-registry:ghcr.io/aguslr/esblue:latest

Features
--------

- Add the following packages to the image:
  + `java-1.8.0-openjdk`
  + [`autofirma-1.8.2-1.noarch_FEDORA.rpm`][4]
  + [`configuradorfnmt-4.0.2-0.x86_64.rpm`][5]

Verification
------------

These images are signed with Sisgstore's [Cosign][6]. You can verify the
signature by downloading the `cosign.pub` key from this repo and running the
following command:

    cosign verify --key cosign.pub ghcr.io/aguslr/esblue


[1]: https://github.com/aguslr/esblue
[2]: https://github.com/aguslr/bluevanilla
[3]: https://github.com/aguslr/bluefusion
[4]: https://firmaelectronica.gob.es/Home/Descargas.html
[5]: https://www.sede.fnmt.gob.es/descargas/descarga-software/instalacion-software-generacion-de-claves
[6]: https://docs.sigstore.dev/cosign/overview/
