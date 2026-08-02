# Nucleus Architecture

Nucleus architecture is a new and unusal way to declaratively configure your
NixOS using flakes. It inspires from dendritic pattern without using
[**hercules-ci/flake-parts**](https://github.com/hercules-ci/flake-parts) or any
complex frameworks like [**denful/den**](https://github.com/denful/den) and
[**numtide/flake-utils**](https://github.com/numtide/flake-utils). It is my
approach to configure NixOS using flake, keeping the configuration dendritic and
modular and also separating reusable parts from host configuration.

## Tech Stack

The nucleus architecture primarily uses flakes as the main tech stack, with the
following 3rd party flakes as core dependencies.

- _**import-tree**_: used for recursively importing *.nix files
- _**home-manager**_: used for declaratively configuring dotfiles in native nix.
- _**nixpkgs**_: uses latest stable instance of nixpkgs for building OS
  generation, using stable pkgs.
- _**nixpkgs-unstable**_: uses rolling release instance of nixpkgs for using
  unstable packages when needed.

### Getting Started

There are two scenarios for getting started with nucleus architecture:

- Starting with NixOS, completely from scratch.
- Migrating to nucleus architecture after fresh installation of NixOS.

#### Coming to NixOS

---

#### Migrating After Fresh Installation
