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
        steam \
        lutris \
        --noconfirm

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
        --noconfirm

# Nvidia Drivers
RUN git clone https://github.com/Frogging-Family/nvidia-all.git && \
    cd nvidia-all && \
    sed -i 's/_driver_branch=""/_driver_branch="regular"/g' customization.cfg && \
    cat PKGBUILD | grep -A 1 "\"\$CONDITION\" = \"2\"" | grep "_driver_version" | head -1 | cut -d '=' -f 2 | cut -d "'" -f 1 > driver.ver && \
    sed -i 's,_driver_version="",_driver_version=\"'"$(cat driver.ver)"'\",g' customization.cfg && \
    sed -i 's/_open_source_modules=""/_open_source_modules="false"/g' customization.cfg && \
    sed -i 's/_dkms=""/_dkms="false"/g' customization.cfg && \
    makepkg -si --noconfirm && \
    cd .. && \
    rm -drf nvidia-all

# Cleanup
USER root
WORKDIR /
RUN userdel -r build && \
    rm -drf /home/build

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
