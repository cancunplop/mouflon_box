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

COPY extra-packages-pip /
RUN grep -v '^#' /extra-packages-pip | \
  xargs pip install  --break-system-packages &&\
  rm /extra-packages-pip

# Atuin
RUN curl -Lo atuin.tar.gz https://github.com/atuinsh/atuin/releases/download/v18.3.0/atuin-v18.3.0-x86_64-unknown-linux-musl.tar.gz && \
  mkdir /usr/share/atuin && \
  tar xzf atuin.tar.gz && \
  cp atuin-*/atuin /usr/bin && \
  cp -r atuin-*/completions /usr/share/atuin && \
  ln -nfs /usr/share/atuin/completions/_atuin /usr/share/zsh/site-functions/ && \
  ln -nfs /usr/share/atuin/completions/atuin.bash /usr/share/bash-completion/ &&\
  ln -nfs /usr/share/atuin/completions/atuin.fish /usr/share/fish/completions/ &&\
  rm -rf atuin-* atuin.tar.gz

# ble.sh
RUN curl -Lo ble.tar.xz https://github.com/akinomyoga/ble.sh/releases/download/v0.4.0-devel3/ble-0.4.0-devel3.tar.xz && \
  mkdir /usr/share/blesh && \
  tar xJf ble.tar.xz -C /usr/share/blesh && \
  mv /usr/share/blesh/ble-0.4.0-devel3/* /usr/share/blesh && \
  rm -f ble.tar.xz && rmdir /usr/share/blesh/ble-0.4.0-devel3

# Cheat
RUN wget https://github.com/cheat/cheat/releases/download/4.4.2/cheat-linux-amd64.gz \
  && gunzip cheat-linux-amd64.gz \
  && chmod +x cheat-linux-amd64 \
  && sudo mv cheat-linux-amd64 /usr/local/bin/cheat

# Lunarvim
RUN LV_BRANCH='release-1.4/neovim-0.9'  XDG_DATA_HOME='/usr/share' INSTALL_PREFIX='/usr' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh) --no-install-dependencies --yes
RUN chmod 755 /usr/bin/lvim
RUN sed -i 's#"/usr/share/lunarvim"#"$HOME/.local/share/lunarvim"#g' /usr/bin/lvim
RUN sed -i 's#"/root/.config/lvim"#"$HOME/.config/lvim"#g' /usr/bin/lvim
RUN sed -i 's#"/root/.cache/lvim"#"$HOME/.cache/lvim"#g' /usr/bin/lvim
RUN ln -nfs /usr/lib/libsqlite3.so.0  /usr/lib/libsqlite3.so

# bat extras
RUN curl -Lo extras.zip https://github.com/eth-p/bat-extras/releases/download/v2024.07.10/bat-extras-2024.07.10.zip && \
  unzip extras.zip -d /tmp && \
  mv /tmp/man/* /usr/share/man/man1/  && \
  mv /tmp/bin/* /usr/bin/ && \
  rm -rf extras.zip /tmp/doc

# fastfetch
RUN curl -Lo fastfetch.tgz https://github.com/fastfetch-cli/fastfetch/releases/download/2.15.0/fastfetch-2.15.0-Linux.tar.gz && \
  tar -xzf fastfetch.tgz -C / && \
  rm fastfetch.tgz

# vivid : https://github.com/sharkdp/vivid
RUN curl -Lo vivid.tgz https://github.com/sharkdp/vivid/releases/download/v0.9.0/vivid-v0.9.0-x86_64-unknown-linux-musl.tar.gz && \
  tar xzf vivid.tgz -C /tmp && \
  mv /tmp/vivid*/vivid /usr/bin/ && \
  rm -rf vivid.tgz /tmp/vivid*

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


