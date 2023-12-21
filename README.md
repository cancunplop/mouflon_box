# boxkit

## Description

boxkit is a set of GitHub actions and skeleton files to build toolbox and distrobox images. Basically, clone this repo, make the changes you want, and then build what you need. Some examples include:

- [DaVinci Box](https://github.com/zelikos/davincibox) - Container for DaVinci Resolve installation and runtime dependencies on Linux
- [obs-studio-portable](https://github.com/ublue-os/obs-studio-portable) - OCI container image of OBS Studio that bundles a curated collection of 3rd party plugins
- [bazzite-arch](https://github.com/ublue-os/bazzite-arch) - A ready-to-game Arch Linux based OCI designed for use exclusively in distrobox

## Boxkit Alpine Example

You can use whatever distribution you want with boxkit, this is the initial example ([here are more](https://github.com/ublue-os/bluefin/tree/main/toolboxes)):

A base image and action for Toolbx and Distrobox.
Sure, you can use the distro you're used to, but what if ... 

This image is going to experiment with what a "born from cloud native" UNIX terminal experience would look like. 
It is used in conjuction with a [dotfile manager](https://dotfiles.github.io/utilities/) like [chezmoi](https://chezmoi.io/) and designed to be the companion terminal experience for cloud-native desktops. 
We're starting small but have big aspirations.

- Starts with the latest Alpine image from the [Toolbx Community Images](https://github.com/toolbx-images/images)
- Adds some quality of life
  - `starship` prompt for that <3
  - `just` for task execution
  - `chezmoi` for dotfile management
  - `btop` for process management
  - `lunarvim` text editor / IDE
  - [clipboard](https://github.com/Slackadays/Clipboard) to cut, copy, and paste anything, anywhere, all from the terminal! 
  - `python3` 
  - Some common power tools: `plocate`, `fzf`, `cosign`, `ripgrep`, `git(hub|lab)-cli`, `bat` and `ffmpeg`
  - CLI tools recommended by [rawkode](https://www.youtube.com/watch?v=TNlDSG1iDW8)
    - [direnv](https://direnv.net/) - environment variable extension for your shell 
    - [atuin](https://github.com/ellie/atuin) - magical shell history
- Host Management QoL
  - These are meant for occasional one off commands, not complex workflows
    - Auto symlink the flatpak, podman, and docker commands
    - Auto symlink rpm-ostree for Fedora
    - Auto symlink transactional-update for openSUSE MicroOS

## How to use

### Create Box

If you use distrobox:

    distrobox create -i ghcr.io/cancunplop/mouflon_box -n boxkit
    distrobox enter boxkit
    
If you use toolbx:

    toolbox create -i ghcr.io/cancunplop/mouflon_box -c boxkit
    toolbox enter boxkit

### Pull down your config

Use `chezmoi` to pull down your dotfiles and set up git sync.


### Make your own

Fork and add programs to this this image - over time you'll end up with the perfect CLI for you.
Keeping it as a pet works, though the author recommends leaving all your config in git and routinely pulling a new image.

The user experience is much nicer if you [set your terminal open right in the container](https://distrobox.privatedns.org/useful_tips/#using-distrobox-as-main-cli) and is the intended experience. 

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/cancunplop/mouflon_box
    
If you're forking this repo you should [read the docs](https://docs.github.com/en/actions/security-guides/encrypted-secrets) on keeping secrets in github. You need to [generate a new keypair](https://docs.sigstore.dev/cosign/overview/) with cosign. The public key can be in your public repo (your users need it to check the signatures), and you can paste the private key in Settings -> Secrets -> Actions.

