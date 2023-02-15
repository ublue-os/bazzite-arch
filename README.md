# bazzite-arch
These images are not meant to be used as a host operating system. Please see [bazzite-desktop](https://github.com/ublue-os/bazzite/) for more information.

## Usage

If you use distrobox:

    distrobox create -i ghcr.io/ublue-os/bazzite-arch -n bazzite-arch
    distrobox enter bazzite-arch

If you use toolbx:

    toolbox create -i ghcr.io/ublue-os/bazzite-arch -c bazzite-arch
    toolbox enter bazzite-arch

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/ublue-os/bazzite-arch
