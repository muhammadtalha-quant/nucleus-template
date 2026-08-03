# Nucleus Architecture

<!--toc:start-->

- [Nucleus Architecture](#nucleus-architecture)
  - [Tech Stack](#tech-stack)
  - [Getting Started](#getting-started)
    - [Coming to NixOS](#coming-to-nixos)
    - [Migrating After Fresh Installation](#migrating-after-fresh-installation)

<!--toc:end-->

Nucleus architecture is a new and unusal way to declaratively configure your
NixOS using flakes. It inspires from dendritic pattern without using
[**hercules-ci/flake-parts**](https://github.com/hercules-ci/flake-parts) or any
complex frameworks like [**denful/den**](https://github.com/denful/den) and
[**numtide/flake-utils**](https://github.com/numtide/flake-utils). It is my
approach to configure NixOS using flake, keeping the configuration dendritic and
modular and also separating reusable parts from host configuration.

## Tech Stack

The nucleus architecture primarily uses flakes as the main tech stack, with the
following flakes as core dependencies.

- _**import-tree**_: used for recursively importing *.nix files
- _**home-manager**_: used for declaratively configuring dotfiles in native nix.
- _**nixpkgs**_: uses latest stable instance of nixpkgs for building OS
  generation, using stable pkgs.
- _**nixpkgs-unstable**_: uses rolling release instance of nixpkgs for using
  unstable packages when needed.

## Getting Started

There are two scenarios for getting started with nucleus architecture:

- Starting with NixOS, completely from scratch.
- Migrating to nucleus architecture after fresh installation of NixOS.

### Coming to NixOS

> [!NOTE]
> This guide assumes that you have formatted,mounted,partitioned disks atleast
> once using cli.

Inside the minimal iso session of NixOS, run the following commands one by one.

- Start with cloning the template repository.

```bash
nix-shell -p git # install git
git clone https://github.com/muhammadtalha-quant/nucleus-template.git
exit # exit the nix-shell 
cd nucleus-template/ # advance into the template repository
```

- Know about your disks.

```bash
lsblk
```

- Open **flake.nix** and do necessary changes.

```bash
nano flake.nix
```

- After edting **flake.nix**, begin installation process with:
-
  - Run disko to handle formatting, partitioning and mounting of your disk.

```bash
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount -f .#YOUR_PREFERRED_HOST_NAME # replace YOUR_PREFERRED_HOST_NAME with the one in flake.nix
```

---

### Migrating After Fresh Installation
