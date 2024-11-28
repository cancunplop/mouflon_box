FROM quay.io/toolbx-images/alpine-toolbox:edge

LABEL com.github.containers.toolbox="true" \
  usage="This image is meant to be used with the toolbox or distrobox command" \
  summary="A cloud-native terminal experience" \
  maintainer="CAncun <plop1@bawah.fr>"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY extra-packages /
RUN apk update && \
  apk upgrade && \
  grep -v '^#' /extra-packages | xargs apk add && \
  rm /extra-packages

COPY extra-packages-testing /
RUN grep -v '^#' /extra-packages-testing | \
  xargs apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ && \
  rm /extra-packages-testing

COPY extra-packages-pip /
RUN grep -v '^#' /extra-packages-pip | \
  xargs pip install  --break-system-packages &&\
  rm /extra-packages-pip

# Atuin
RUN curl -Lo atuin.tar.gz https://github.com/atuinsh/atuin/releases/download/v18.3.0/atuin-x86_64-unknown-linux-musl.tar.gz && \
  mkdir /usr/share/atuin && \
  tar xzf atuin.tar.gz && \
  cp atuin-*/atuin /usr/bin && \
  rm -rf atuin-* atuin.tar.gz

# ble.sh
RUN curl -Lo ble.tar.xz https://github.com/akinomyoga/ble.sh/releases/download/v0.4.0-devel3/ble-0.4.0-devel3.tar.xz && \
  mkdir /usr/share/blesh && \
  tar xJf ble.tar.xz -C /usr/share/blesh && \
  mv /usr/share/blesh/ble-0.4.0-devel3/* /usr/share/blesh && \
  rm -f ble.tar.xz && rmdir /usr/share/blesh/ble-0.4.0-devel3

# Cheat
RUN curl -Lo  cheat-linux-amd64.gz https://github.com/cheat/cheat/releases/download/4.4.2/cheat-linux-amd64.gz \
  && gunzip cheat-linux-amd64.gz \
  && chmod +x cheat-linux-amd64 \
  && mv cheat-linux-amd64 /usr/local/bin/cheat

# Lunarvim
RUN LV_BRANCH='release-1.4/neovim-0.9'  XDG_DATA_HOME='/usr/share' INSTALL_PREFIX='/usr' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh) --no-install-dependencies --yes && \
    chmod 755 /usr/bin/lvim && \
    sed -i 's#"/usr/share/lunarvim"#"$HOME/.local/share/lunarvim"#g' /usr/bin/lvim && \
    sed -i 's#"/root/.config/lvim"#"$HOME/.config/lvim"#g' /usr/bin/lvim && \
    sed -i 's#"/root/.cache/lvim"#"$HOME/.cache/lvim"#g' /usr/bin/lvim && \
    ln -nfs /usr/lib/libsqlite3.so.0  /usr/lib/libsqlite3.so

# bat extras
RUN curl -Lo extras.zip https://github.com/eth-p/bat-extras/releases/download/v2024.08.24/bat-extras-2024.08.24.zip && \
  unzip extras.zip -d /tmp && \
  mv /tmp/man/* /usr/share/man/man1/  && \
  mv /tmp/bin/* /usr/bin/ && \
  rm -rf extras.zip /tmp/doc

# fastfetch
RUN curl -Lo fastfetch.tgz https://github.com/fastfetch-cli/fastfetch/releases/download/2.30.1/fastfetch-musl-amd64.tar.gz && \
  tar -xzf fastfetch.tgz -C / && \
  rm fastfetch.tgz

# vivid : https://github.com/sharkdp/vivid
RUN curl -Lo vivid.tgz https://github.com/sharkdp/vivid/releases/download/v0.10.1/vivid-v0.10.1-x86_64-unknown-linux-musl.tar.gz && \
  tar xzf vivid.tgz -C /tmp && \
  mv /tmp/vivid*/vivid /usr/bin/ && \
  rm -rf vivid.tgz /tmp/vivid*

# clean
RUN apk del \
  vim \
  vimdiff


RUN ln -fs /bin/sh /usr/bin/sh && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \ 
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update


