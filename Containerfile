FROM quay.io/toolbx-images/alpine-toolbox:edge

LABEL com.github.containers.toolbox="true" \
  usage="This image is meant to be used with the toolbox or distrobox command" \
  summary="A cloud-native terminal experience" \
  maintainer="CAncun <plop1@bawah.fr>"

USER root 
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY extra-packages /
RUN if [ -s /extra-packages ]; then \
  apk upgrade && \
  grep -v '^#' /extra-packages | xargs apk add && \
  rm /extra-packages; \
  fi

COPY extra-packages-testing /
RUN if [ -s /extra-packages-testing ]; then \
  grep -v '^#' /extra-packages-testing | \
  xargs apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ && \
  rm /extra-packages-testing; \
  fi

COPY extra-packages-pip /
RUN if [ -s /extra-packages-pip ]; then \
  grep -v '^#' /extra-packages-pip | \
  xargs pip install  --break-system-packages &&\
  rm /extra-packages-pip; \
  fi

# Atuin
RUN curl -L https://github.com/atuinsh/atuin/releases/download/v18.4.0/atuin-x86_64-unknown-linux-musl.tar.gz | \
  tar -xz --wildcards --no-anchored --strip-components 1 -C /usr/bin/ '*/atuin'

# ble.sh
RUN mkdir /usr/share/blesh && \
  curl -L https://github.com/akinomyoga/ble.sh/releases/download/v0.4.0-devel3/ble-0.4.0-devel3.tar.xz | \
  tar -xJ -C /usr/share/blesh --strip-components 1

# Cheat
RUN curl -L https://github.com/cheat/cheat/releases/download/4.4.2/cheat-linux-amd64.gz | \
  gunzip - > /usr/local/bin/cheat && \
  chmod +x /usr/local/bin/cheat

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


