# bazzite-arch

[![build-bazzite-arch](https://github.com/ublue-os/bazzite-arch/actions/workflows/build.yml/badge.svg)](https://github.com/ublue-os/bazzite-arch/actions/workflows/build.yml) 

These images are not meant to be used as a host operating system. Please see [bazzite-desktop](https://github.com/ublue-os/bazzite/) for more information.

## Usage

    distrobox create -i ghcr.io/ublue-os/bazzite-arch -n bazzite-arch
    distrobox enter bazzite-arch

### Nvidia

Ensure the [Nvidia Container Runtime](https://developer.nvidia.com/nvidia-container-runtime) is installed, this comes pre-installed on all ublue Nvidia flavors.

    distrobox create -i ghcr.io/ublue-os/bazzite-arch -n bazzite-arch --additional-flags "--runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=all -e NVIDIA_DRIVER_CAPABILITIES=all"
    distrobox enter bazzite-arch

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/ublue-os/bazzite-arch
