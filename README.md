# bazzite-arch

[![build-bazzite-arch](https://github.com/ublue-os/bazzite-arch/actions/workflows/build.yml/badge.svg)](https://github.com/ublue-os/bazzite-arch/actions/workflows/build.yml) 

Bazzite-Arch is a ready-to-game [Arch Linux](https://archlinux.org/) based OCI designed for use exclusively in [distrobox](https://github.com/89luca89/distrobox). It is part of the [Bazzite](https://github.com/ublue-os/bazzite/) project and is used for running Steam, Lutris, and Protontricks in the desktop images. It may also be used on any Linux distributon by following the usage section below.

## Usage

**For AMD/Intel GPU systems:**

    distrobox create -i ghcr.io/ublue-os/bazzite-arch -n bazzite-arch

**For Nvidia GPU systems:**

    distrobox create -i ghcr.io/ublue-os/bazzite-arch -n bazzite-arch --nvidia

Once the image has been created, you may optionally export the pre-installed applications to your host operating system using the following:

    distrobox-enter -n bazzite-arch -- '  distrobox-export --app steam'
    distrobox-enter -n bazzite-arch -- '  distrobox-export --app lutris'
    distrobox-enter -n bazzite-arch -- '  distrobox-export --app protontricks'
    mkdir -p ~/.steam
    distrobox-enter -n bazzite-arch -- '  distrobox-export --bin /usr/bin/steamcmd --export-path ~/.steam'
    mv ~/.steam/steamcmd ~/.steam/steamcmd.sh

For desktop environments other than KDE, you may want to change the xdg-desktop-portal package. The command below will switch Bazzite-Arch to `xdg-desktop-portal-gnome`:

    distrobox-enter -n bazzite-arch -- '  sudo pacman -Rnsdd xdg-desktop-portal-kde --noconfirm && sudo pacman -S xdg-desktop-portal-gnome --noconfirm'

On AMD systems you can add [ROCm GPU Compute](https://www.amd.com/en/graphics/servers-solutions-rocm) with the following:

    distrobox-enter -n bazzite-arch -- '  sudo pacman -S rocm-opencl-runtime rocm-hip-runtime --noconfirm'

Bazzite-Arch ships with [paru](https://github.com/Morganamilo/paru) pre-installed, and comes with a modified [xdg-utils](https://github.com/KyleGospo/xdg-utils-distrobox-arch) that allows the container to open your host operating system's web browsers and file explorer.

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/ublue-os/bazzite-arch
