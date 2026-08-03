# Nucleus Architecture

<!--toc:start-->

- [Nucleus Architecture](#nucleus-architecture)
  - [Tech Stack](#tech-stack)
  - [Tree Structure](#tree-structure)
  - [Core Concepts](#core-concepts)
    - [Common](#common)
    - [Features](#features)
    - [Hosts](#hosts)
  - [Getting Started](#getting-started)
    - [Coming to NixOS From Other Distributions](#coming-to-nixos-from-other-distributions)
      - [Clone The Template Repository](#clone-the-template-repository)
      - [Make Changes According To Your Liking](#make-changes-according-to-your-liking)
      - [Installing NixOS from Modified Template](#installing-nixos-from-modified-template)
    - [Migrating After Fresh Installation of NixOS](#migrating-after-fresh-installation-of-nixos)
      - [Clone The Template Repository](#clone-the-template-repository-1)
      - [Make Changes According to Your Current System State](#make-changes-according-to-your-current-system-state)
  - [Acknowledgments](#acknowledgments)
  - [LICENSE](#license)

<!--toc:end-->

Nucleus Architecture is a new and unusal way to declaratively configure NixOS
using flakes. It is inspired from dendritic pattern but without using
[**hercules-ci/flake-parts**](https://github.com/hercules-ci/flake-parts) or any
complex frameworks like [**denful/den**](https://github.com/denful/den) and
[**numtide/flake-utils**](https://github.com/numtide/flake-utils). It is my
approach to configure NixOS using flake, keeping the configuration
dendritic-like and modular and also separating reusable parts from host
configuration.

> [!CAUTION]
> This architecture is strictly designed for personal NixOS configurations. For
> production use, please default to
> [**hercules-ci/flake-parts**](https://github.com/hercules-ci/flake-parts) or
> [**denful/den**](https://github.com/denful/den).

## Tech Stack

The nucleus architecture primarily uses flakes as the main foundation, with the
following flakes as core dependencies.

- _**import-tree**_: used for recursively importing *.nix files
- _**home-manager**_: used for declaratively configuring dotfiles in native nix.
- _**nixpkgs**_: uses latest stable instance of nixpkgs for building OS
  generation, using stable pkgs.
- _**nixpkgs-unstable**_: uses rolling release instance of nixpkgs for using
  unstable packages when needed.

## Tree Structure

```text
 .
├──  flake.nix # logical control center
├──  modules
│   ├──  common # a directory that stores common configuration for all hosts.
│   │   └──  disko.nix
│   ├──  features # a directory that stores reusable features for all hosts.
│   │   ├──  configuration # your OS configuration lives here.
│   │   │   ├──  configuration.nix # main OS entry point
│   │   │   └──  modules # a directory where your configuration modules will live.
│   │   └──  dotfiles # your user configuration lives here.
│   │       ├──  home.nix # minimal home.nix to get you started.
│   │       └──  modules # a directory where dotfiles modules will live.
│   └──  hosts # a directory that stores each host and its hardware specific configuration.
│       └──  YOUR_PREFERRED_HOST_NAME 
│           ├──  default.nix # file that declares hardware specific drivers, kernel modules etc.
│           └──  hardware-configuration.nix # generated configuration by NixOS installer.
│           
└── 󰂺 README.md ← You are reading !
```

## Core Concepts

Nucleus organizes configuration into three layers:

### Common

Configuration shared by every machine.

Examples:

- disko layout
- global nix settings
- shared overlays

### Features

Reusable system capabilities.

Examples:

- desktop environments
- services
- development tools
- applications

### Hosts

Machine-specific configuration.

Examples:

- hardware configuration
- kernel modules
- drivers
- filesystem information

## Getting Started

There are two scenarios for getting started with nucleus architecture:

- Coming to NixOS from other distros.
- Migrating After Fresh NixOS Installation.

### Coming to NixOS From Other Distributions

> [!NOTE]
> This guide assumes that you have formatted,mounted,partitioned disks atleast
> once using cli.

Inside the minimal iso session of NixOS, run the following commands one by one.

#### Clone The Template Repository

```bash
sudo -i # enter root mode, as per nixos manual
nix-shell -p git # install git
git clone https://github.com/muhammadtalha-quant/nucleus-template.git
exit # exit the git shell
cd nucleus-template/ # advance into the template repository
rm -rf .git # remove repo metadata, so you make it your own
```

#### Make Changes According To Your Liking

- Know your disk by running the following command.

```bash
lsblk
```

- Open **flake.nix** and do necessary changes as documented.

```bash
nano flake.nix
```

#### Installing NixOS from Modified Template

- Rename hosts directory to avoid errors.

  ```bash
  mv modules/hosts/YOUR_PREFERRED_HOST_NAME modules/hosts/HOST_NAME_YOU_SET
  ```

- Run disko to handle formatting, partitioning and mounting of your disk.

> [!WARNING]
> The disko command will destroy the target disk according to your
> configuration. Verify your disk layout before running it.

```bash
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount -f .#YOUR_PREFERRED_HOST_NAME
```

- Installing NixOS

  ```bash
  cd .. # exit the repository 
  mv nucleus-template /mnt/
  cd /mnt/nucleus-template/
  nixos-generate-config --root . --dir modules/hosts/YOUR_PREFERRED_HOST_NAME/ --no-filesystems
  rm modules/hosts/YOUR_PREFERRED_HOST_NAME/configuration.nix
  nixos-install --flake .#YOUR_PREFERRED_HOST_NAME --no-root-passwd
  ```

### Migrating After Fresh Installation of NixOS

Migration after fresh installation of NixOS is relatively simple.

#### Clone The Template Repository

> [!IMPORTANT]
> Make sure you have `git` installed on your system. Before migrating, it is
> important to skim atleast every nix file of the repository.

- Open your default terminal, and paste the following command

```bash
git clone https://github.com/muhammadtalha-quant/nucleus-template.git && cd nucleus-template/
rm -rf .git # remove repo metadata to make it your own.
```

#### Make Changes According to Your Current System State

- Prelimenary Steps

```bash
rm -frv modules/features/configuration/*
rm -frv modules/hosts/YOUR_PREFERRED_HOST_NAME/*
mv /etc/nixos/configuration.nix modules/features/configuration/
nano modules/features/configuration/configuration.nix # import default.nix from your host
mv /etc/nixos/hardware-configuration.nix modules/hosts/YOUR_PREFERRED_HOST_NAME/
mv modules/hosts/YOUR_PREFERRED_HOST_NAME modules/hosts/HOST_NAME_YOU_SET_IN_INSTALLATION
nano modules/hosts/HOST_NAME_YOU_SET_IN_INSTALLATION/hardware-configuration.nix # remove fileSystems attrs.
nano flake.nix # remove stuff you don't need, modularize your system slowly.
nixos-rebuild-switch --flake .#YOUR_PREFERRED_HOST_NAME
```

> [!TIP]
> The first thing to look for in **flake.nix** is to pin nixpkgs to latest
> stable release. If you are confused or have no idea about modularization, you
> have can explore my
> [personal configuration](https://github.com/muhammadtalha-quant/nucleonix).

## Acknowledgments

**Nucleus Architecture** made with Love++ and AI--. Contributions are welcome,
you can contribute in any way you like.

## LICENSE

The Unlicense OR MIT
