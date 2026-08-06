# Nucleus Architecture

<!--toc:start-->

- [Nucleus Architecture](#nucleus-architecture)
  - [Introduction](#introduction)
  - [Goals](#goals)
  - [Scope](#scope)
  - [Host Management Model](#host-management-model)
  - [Non-goals](#non-goals)
  - [Tech Stack](#tech-stack)
  - [Tree Structure](#tree-structure)
    - [Core Concepts](#core-concepts)
      - [Common](#common)
      - [Features](#features)
      - [Hosts](#hosts)
  - [Getting Started](#getting-started)
    - [Coming to NixOS From Other Distributions](#coming-to-nixos-from-other-distributions)
      - [Clone The Template Repository](#clone-the-template-repository)
      - [Preparation and Installation](#preparation-and-installation)
      - [Installing NixOS from Modified Template](#installing-nixos-from-modified-template)
    - [Migrating After Fresh Installation of NixOS](#migrating-after-fresh-installation-of-nixos)
      - [Clone The Template Repository](#clone-the-template-repository-1)
      - [Preparation and Building](#preparation-and-building)
  - [Acknowledgments](#acknowledgments)
  - [Footnotes](#footnotes)
  - [LICENSE](#license)

<!--toc:end-->

## Introduction

Nucleus Architecture is a lightweight approach to organizing declarative NixOS
configurations using flakes.

It is inspired by the dendritic pattern, while intentionally avoiding additional
configuration frameworks such as
[**hercules-ci/flake-parts**](https://github.com/hercules-ci/flake-parts),
[**denful/den**](https://github.com/denful/den), or
[**numtide/flake-utils**](https://github.com/numtide/flake-utils).

Nucleus focuses on keeping configurations modular and understandable by
separating reusable components from host-specific configuration.

It is my approach to structuring personal NixOS systems using native NixOS
concepts while maintaining a clear separation between shared configuration,
reusable features, and individual machines.

## Goals

Nucleus aims to provide:

- A predictable structure for personal NixOS configurations.
- Clear separation between shared configuration, reusable features, and
  host-specific details.
- A reproducible installation and migration workflow.
- A configuration layout that remains understandable over long periods of time.
- A practical starting point for users who want to build and maintain their own
  NixOS systems.

## Scope

Nucleus is designed for personal NixOS configurations.

It can comfortably support configurations with multiple machines, such as:

- personal laptops
- desktops
- home servers
- development machines

Nucleus can technically support many hosts, but it is optimized for personal
ownership rather than large-scale fleet management. Ideally, a setup with less
than 10 individual hosts should remain straightforward to maintain with this
architecture.

The architecture assumes that the person maintaining the configuration
understands the design decisions behind it. For larger teams or deployments
where many people manage many machines, dedicated infrastructure-oriented
frameworks may be more appropriate.

> [!CAUTION]
>
> - This architecture is strictly designed for personal NixOS configurations.
> - For production use, please default to
>   [**hercules-ci/flake-parts**](https://github.com/hercules-ci/flake-parts) or
>   [**denful/den**](https://github.com/denful/den).
> - Only **UEFI** systems are supported.

## Host Management Model

Nucleus follows a host-oriented configuration model.

The repository can contain multiple hosts, but each host is treated as an
individual system with its own requirements and configuration.

When adding a new host:

1. Start from the existing architecture.
2. Adapt features according to the needs of that machine.
3. Move host-specific configuration into the corresponding host directory.
4. Import and maintain the configuration for that host independently.

Nucleus does not aim to be a centralized fleet management system where every
machine is controlled from a single configuration repository.

While technically possible, managing a large number of hosts from one repository
requires additional processes and is outside the intended scope of this
architecture.

## Non-goals

Nucleus is intentionally not designed to:

- Replace general-purpose Nix configuration frameworks.
- Provide fleet management or infrastructure deployment features.
- Solve every possible NixOS configuration scenario.
- Become a universal standard for organizing NixOS systems.

Nucleus is designed specifically for personal NixOS configurations where
simplicity, ownership, and maintainability are the priority.

## Tech Stack

The nucleus architecture primarily uses flakes as the main foundation, with the
following flakes as core dependencies.

- _**import-tree:**_ used for recursively importing *.nix files
- _**home-manager:**_ used for declaratively configuring dotfiles in native nix.
- _**disko:**_ used to declaratively automate the formatting, partitioning and
  mounting of the target disk.
- _**nixpkgs:**_ uses latest stable instance of nixpkgs for building OS
  generation, using stable packages.
- _**nixpkgs-unstable:**_ uses rolling release instance of nixpkgs for using
  unstable packages when needed.

## Tree Structure

```text
.
├── flake.nix
├── LICENSE
├── modules
│   ├── common
│   │   └── disko.nix
│   ├── features
│   │   ├── configuration
│   │   │   ├── configuration.nix
│   │   │   └── modules
│   │   │       ├── bootloader.nix
│   │   │       ├── hardware.nix
│   │   │       ├── i18n.nix
│   │   │       ├── networking.nix
│   │   │       ├── nh.nix
│   │   │       ├── nix.nix
│   │   │       ├── security.nix
│   │   │       ├── services.nix
│   │   │       └── users.nix
│   │   └── dotfiles
│   │       └── home.nix
│   └── hosts
│       └── «hostname»
│           ├── default.nix
│           └── hardware-configuration.nix
└── README.md
```

### Core Concepts

Nucleus organizes configuration into three layers:

#### Common

Configuration shared by every machine.

Examples:

- disko layout
- shared overlays

#### Features

Reusable system capabilities.

Examples:

- desktop environments
- services
- development tools
- applications

#### Hosts

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
> This guide assumes that you have formatted, mounted and partitioned disks at
> least once using cli.

Inside the minimal iso session of NixOS, run the following commands one by one.

#### Clone The Template Repository

- Clone the template repository
  - Enter root mode as suggested in the NixOS Manual.
  - Since `git` is not available in the minimal ISO of NixOS, we have to install
    it in a temporary shell.
  - Clone the repository.
  - Exit the shell that provided `git`.
  - Remove the `.git` directory, so that the process doesn't throw errors
    regarding impurity[^1].

```bash
sudo -i 
nix-shell -p git 
git clone https://github.com/muhammadtalha-quant/nucleus-template.git
exit 
cd nucleus-template/ 
rm -rf .git
```

#### Preparation and Installation

- Know your disk by running the following command.

```bash
lsblk
```

- Open **flake.nix** and do necessary changes as documented.

```bash
nano flake.nix
```

#### Installing NixOS from Modified Template

- Rename `«hostname»` directory to avoid errors.

  ```bash
  mv modules/hosts/«hostname» modules/hosts/«preferred_hostname»
  ```

- Run disko to handle formatting, partitioning and mounting of your disk.

> [!WARNING]
> The disko command will destroy the target disk according to your
> configuration. Verify your disk layout before running it.

```bash
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount -f .#«preferred_hostname»
```

> [!IMPORTANT]
> If you are on laptop, make sure to check out
> [services.nix](modules/features/configuration/modules/services.nix) and enable
> power management services.

- Installing NixOS
  - Go to parent directory of template repo.
  - Move repository to `/mnt` so that it is available after installation.
  - Change directory to repository in the new location.
  - Generate configuration in the `«preferred_hostname»` directory.
  - Remove the generated `configuration.nix` stub.
  - Install NixOS from the modified template and do not prompt for root
    password.

```bash
cd .. 
mv nucleus-template /mnt/
cd /mnt/nucleus-template/
nixos-generate-config --root . --dir modules/hosts/«preferred_hostname»/ --no-filesystems
rm modules/hosts/«preferred_hostname»/configuration.nix
nixos-install --flake .#«preferred_hostname» --no-root-passwd
```

### Migrating After Fresh Installation of NixOS

Migration after fresh installation of NixOS is relatively simple.

#### Clone The Template Repository

> [!IMPORTANT]
> Make sure you have `git` installed on your system. Before migrating, it is
> important to skim at least every nix file of the repository.

- Open your default terminal, and paste the following command
  - Clone the template repository.
  - Change directory into the repository.
  - Remove the `.git` directory, so that the process doesn't throw errors
    regarding impurity[^1].

```bash
git clone https://github.com/muhammadtalha-quant/nucleus-template.git 
cd nucleus-template/
rm -rf .git
```

#### Preparation and Building

> [!NOTE]
> Please make sure to edit `disko.nix` and reproduce/declare your exact disk
> config, that you are running currently otherwise you are going to end up in
> un-repairable state and you will have to reinstall NixOS if you dont have
> previous generations. Disko provides lots of templates, check them out
> [here](https://github.com/nix-community/disko/tree/master/example).

When you are done with disko, now is the time to manually add PARTLABELs using
parted. In the given [disko.nix](./modules/common/disko.nix), the correct label
for **ESP** partition would be `disk-my-disk-ESP` as you can see the partition
is defined as `disk.my-disk.content.partitions.ESP` under `disko.devices`.
Similarly, the correct labels for **swap** and **root** partitions would be
`disk-my-disk-swap` and `disk-my-disk-root` respectively.</br> Make sure that
the GNU Parted Utility is installed and available as `parted`. The following
commands demonstrate how to add labels to your partitions.

> [!CAUTION]
> The following commands are according to the
> [disko.nix](./modules/common/disko.nix) in this repository.

```bash
sudo parted /dev/name
(parted) print 
(parted) name 1 disk-my-disk-ESP
(parted) name 2 disk-my-disk-swap
(parted) name 3 disk-my-disk-root
(parted) print 
(parted) quit
```

- Preparing the template
  - Remove given starter configuration from template
  - Remove hardware-configuration.nix stub from template
  - Change ownership of installer generated files so you dont prefix each
    command with sudo.
  - Move the installer generated files to directories defined by template.
  - Rename `«hostname»` directory to the actual host name you set during
    installation i-e `«preferred_hostname»`.

```bash
rm -frv modules/features/configuration/*
rm -frv modules/hosts/«hostname»/hardware-configuration.nix
sudo chown -R «username»:users /etc/nixos/*
mv /etc/nixos/configuration.nix modules/features/configuration/
mv /etc/nixos/hardware-configuration.nix modules/hosts/«preferred_hostname»/
mv modules/hosts/«hostname» modules/hosts/«preferred_hostname»
```

- Do the required changes
  - Open `configuration.nix` and replace `hardware-configuration.nix` from its
    imports list with `../../hosts/${hostName}/default.nix`.
  - Open `hardware-configuration.nix` and remove `fileSystems` attribute set to
    avoid conflicts with disko.
  - Open `flake.nix` and replace placeholders with your actual values
  - Build the OS generation with `nixos-rebuild switch`

```bash
nano modules/features/configuration/configuration.nix
nano modules/hosts/«preferred_hostname»/hardware-configuration.nix 
nano flake.nix 
nixos-rebuild switch --flake .#«preferred_hostname»
```

> [!TIP]
> The first thing to look for in **flake.nix** is to pin nixpkgs to latest
> stable release available. If you are confused or have no idea about
> modularization, you have can explore my
> [personal configuration](https://github.com/muhammadtalha-quant/nucleonix).

## Acknowledgments

**Nucleus Architecture** made with Love++ and AI--. Contributions are welcome,
you can contribute in any way you like.

## Footnotes

- [^1]: Impurity is Nix flake concept wherein if your flake repository does not track latest changes then your repository is considered impure and the build will fail. This error is often thrown during build process when a new file is not added to repository, although it exists in the directory.


## LICENSE

BSD 3-Clause License

