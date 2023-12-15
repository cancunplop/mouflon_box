FROM quay.io/toolbx-images/alpine-toolbox:edge

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="jorge.castro@gmail.com"

COPY extra-packages /
RUN apk update && \
    apk upgrade && \
    grep -v '^#' /extra-packages | xargs apk add && \
    rm /extra-packages

# DUF
RUN apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ duf

# Atuin pre-req : ble.sh
RUN curl -Lo ble.tar.xz https://github.com/akinomyoga/ble.sh/releases/download/v0.4.0-devel3/ble-0.4.0-devel3.tar.xz && \
    mkdir /usr/share/blesh && \
    tar xJf ble.tar.xz -C /usr/share/blesh && \
    mv /usr/share/blesh/ble-0.4.0-devel3/* /usr/share/blesh && \
    rm -f ble.tar.xz && rmdir /usr/share/blesh/ble-0.4.0-devel3

# Lunarvim
RUN LV_BRANCH='release-1.3/neovim-0.9' INSTALL_PREFIX='/' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh) --no-install-dependencies --yes
RUN ln -nfs /usr/lib/libsqlite3.so.0  /usr/lib/libsqlite3.so

# bat catpuccin theme
RUN git clone https://github.com/catppuccin/bat.git && \
    mkdir -p "$(bat --config-dir)/themes" && \
    cp bat/*.tmTheme "$(bat --config-dir)/themes" && \
    bat cache --build && \
    rm -rf bat

# bat extras
RUN curl -Lo extras.zip https://github.com/eth-p/bat-extras/releases/download/v2023.09.19/bat-extras-202309.19.zip && \
    unzip extras.zip -d / && \
    rm -f extras.zip

# clean
RUN apk del \
  vim \
  vimdiff


RUN   ln -fs /bin/sh /usr/bin/sh && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \ 
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update
     

