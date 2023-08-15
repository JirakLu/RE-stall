FROM archlinux:latest

RUN pacman-key --init
RUN pacman --noconfirm -Syu
RUN pacman --noconfirm -S sudo diffutils

# Setup yay
RUN pacman --noconfirm -S base-devel git

RUN mkdir -p /tmp/yay-build
RUN useradd -m -G wheel builder && passwd -d builder
RUN chown -R builder:builder /tmp/yay-build
RUN echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN su - builder -c "git clone https://aur.archlinux.org/yay.git /tmp/yay-build/yay"
RUN su - builder -c "cd /tmp/yay-build/yay && makepkg -si --noconfirm"
RUN rm -rf /tmp/yay-build

COPY ./PHP /home/builder/scripts/PHP
RUN chown -R builder:builder /home/builder/scripts


