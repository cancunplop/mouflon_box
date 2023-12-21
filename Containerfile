FROM quay.io/toolbx-images/alpine-toolbox:edge

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="CAncun <plop1@bawah.fr>"

COPY extra-packages /
RUN apk update && \
    apk upgrade && \
    grep -v '^#' /extra-packages | xargs apk add && \
    rm /extra-packages

COPY extra-packages-testing /
RUN grep -v '^#' /extra-packages-testing | \
    xargs apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ && \
    rm /extra-packages-testing

# DUF
RUN apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ duf

# Atuin
RUN curl -Lo atuin.tgz https://github.com/atuinsh/atuin/releases/download/v17.1.0/atuin-v17.1.0-x86_64-unknown-linux-musl.tar.gz && \
    mkdir /usr/share/atuin && \
    tar xzf atuin.tgz && \
    cp atuin-*/atuin /usr/bin && \
    cp -r atuin-*/completions /usr/share/atuin && \
    rm -rf atuin-* atuin.tgz

# ble.sh
RUN curl -Lo ble.tar.xz https://github.com/akinomyoga/ble.sh/releases/download/v0.4.0-devel3/ble-0.4.0-devel3.tar.xz && \
    mkdir /usr/share/blesh && \
    tar xJf ble.tar.xz -C /usr/share/blesh && \
    mv /usr/share/blesh/ble-0.4.0-devel3/* /usr/share/blesh && \
    rm -f ble.tar.xz && rmdir /usr/share/blesh/ble-0.4.0-devel3

# Lunarvim
RUN LV_BRANCH='release-1.3/neovim-0.9'  XDG_DATA_HOME='/usr/share' INSTALL_PREFIX='/usr' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh) --no-install-dependencies --yes
RUN chmod 755 /usr/bin/lvim
RUN ln -nfs /usr/lib/libsqlite3.so.0  /usr/lib/libsqlite3.so

# bat extras
RUN curl -Lo extras.zip https://github.com/eth-p/bat-extras/releases/download/v2023.09.19/bat-extras-202309.19.zip && \
    unzip extras.zip -d /tmp && \
    mv /tmp/man/* /usr/share/man/man1/  && \
    mv /tmp/bin/* /usr/bin/ && \
    rm -rf extras.zip /tmp/doc

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
     

