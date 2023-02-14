FROM docker.io/library/archlinux:latest

# Install needed packages
RUN sed -i 's/#Color/Color/g' /etc/pacman.conf && \
    printf "[multilib]\nInclude = /etc/pacman.d/mirrorlist\n" | tee -a /etc/pacman.conf && \
    sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/g' /etc/makepkg.conf && \
    pacman -Syu --noconfirm && \
    pacman -S \
        wget \
        base-devel \
        git \
        nvidia-utils \
        vulkan-radeon \
        lib32-vulkan-radeon \
        libva-mesa-driver \
        intel-media-driver \
        openal \
        pipewire \
        pipewire-pulse \
        pipewire-alsa \
        pipewire-jack \
        lib32-pipewire \
        lib32-pipewire-jack \
        lib32-libpulse \
        lib32-openal \
        --noconfirm && \
    pacman -S \
        wine \
        steam \
        lutris \
        --noconfirm
        # Steam/Lutris/Wine installed separately so they use the dependencies above and don't try to install their own.

# Add yay and install AUR packages
RUN useradd -m --shell=/bin/bash build && usermod -L build && \
    echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER build
WORKDIR /home/build
RUN git config --global protocol.file.allow always && \
    git clone https://aur.archlinux.org/yay-bin.git && \
    cd yay-bin && \
    makepkg -si --noconfirm && \
    cd .. && \
    rm -drf yay-bin && \
    yay -S \
        aur/protontricks \
        aur/vkbasalt \
        aur/lib32-vkbasalt \
        aur/mangohud \
        aur/lib32-mangohud \
        aur/latencyflex-git \
        aur/latencyflex-wine-git \
        aur/opencl-amd \
        --noconfirm
USER root
WORKDIR /

# Integrate with the host
RUN git clone https://github.com/89luca89/distrobox.git && \
    cp distrobox/distrobox-host-exec /usr/bin/distrobox-host-exec && \
    rm -f /usr/bin/xdg-open && \
    ln -s /usr/bin/distrobox-host-exec /usr/bin/xdg-open && \
    ln -s /usr/bin/distrobox-host-exec /usr/bin/flatpak && \
    ln -s /usr/bin/distrobox-host-exec /usr/bin/firefox && \
    wget https://github.com/1player/host-spawn/releases/download/$(cat distrobox/distrobox-host-exec | grep host_spawn_version= | cut -d "\"" -f 2)/host-spawn-$(uname -m) -O distrobox/host-spawn && \
    cp distrobox/host-spawn /usr/bin/host-spawn && \
    chmod +x /usr/bin/host-spawn && \
    rm -drf distrobox

# Native march & tune. This is a gaming image and not something a user is going to compile things in with the intent to share.
# We do this last because it'll only apply to updates the user makes going forward. We don't want to optimize for the build host's environment.
RUN sed -i 's/-march=x86-64 -mtune=generic/-march=native -mtune=native/g' /etc/makepkg.conf

# Cleanup
RUN userdel -r build && \
    rm -drf /home/build && \
    sed -i '/build ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
    sed -i '/root ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
    rm -rf \
    /tmp/* \
    /var/*
