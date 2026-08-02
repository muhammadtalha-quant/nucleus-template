# Nucleus Architecture

Nucleus architecture is a new and unusal way to declaratively configure your
NixOS using flakes. It inspires from dendritic pattern without using
[**hercules-ci/flake-parts**](https://github.com/hercules-ci/flake-parts) or any
complex frameworks like [**denful/den**](https://github.com/denful/den) and
[**numtide/flake-utils**](https://github.com/numtide/flake-utils). It is my
approach to configure NixOS using flake, keeping the configuration dendritic and
modular and also separating reusable parts from host configuration.
