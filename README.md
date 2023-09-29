# bazzite-arch

[![build-bazzite-arch](https://github.com/ublue-os/bazzite-arch/actions/workflows/build.yml/badge.svg)](https://github.com/ublue-os/bazzite-arch/actions/workflows/build.yml) 

Bazzite-Arch is a ready-to-game [Arch Linux](https://archlinux.org/) based OCI designed for use exclusively in [distrobox](https://github.com/89luca89/distrobox). It is part of the [Bazzite](https://github.com/ublue-os/bazzite/) project and is used for running Steam, Lutris, and Protontricks in the desktop images. It may also be used on any Linux distributon by following the usage section below.

## Usage

    distrobox create --nvidia --image ghcr.io/ublue-os/bazzite-arch --name bazzite-arch

<sub>For the GNOME desktop environment, you may want to replace `ghcr.io/ublue-os/bazzite-arch` in the above command with `ghcr.io/ublue-os/bazzite-arch-gnome`, which comes with `xdg-desktop-portal-gtk`.</sub>

Once the image has been created, you may optionally export the pre-installed applications to your host operating system using the following:

    distrobox-enter -n bazzite-arch -- '  distrobox-export --app steam'
    distrobox-enter -n bazzite-arch -- '  distrobox-export --app lutris'
    distrobox-enter -n bazzite-arch -- '  distrobox-export --app protontricks'
    distrobox-enter -n bazzite-arch -- '  mkdir -p ~/.steam && distrobox-export --bin /usr/bin/steamcmd --export-path ~/.steam && mv ~/.steam/steamcmd ~/.steam/steamcmd.sh'

Bazzite-Arch is built from [arch-distrobox](https://github.com/ublue-os/arch-distrobox), which ships with [paru](https://github.com/Morganamilo/paru) pre-installed, along with a modified [xdg-utils](https://github.com/KyleGospo/xdg-utils-distrobox-arch) that allows the container to open your host operating system's web browsers and file explorer.

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/ublue-os/bazzite-arch
