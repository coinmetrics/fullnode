# Unofficial fullnode images

Docker Hub: [coinmetrics/](https://hub.docker.com/r/coinmetrics/)

This repo contains scripts to build fullnode images of various blockchains by Coin Metrics.

These images are being used internally at Coin Metrics, and are published in the hope they will be useful, but without any warranty.
No support is available. You are using them at your own risk.

This repository is **new**, **experimental**, and **work in progress**. If you want more stable experience, please consider the [Fullnodes](https://gitlab.com/coinmetrics/fullnodes) group of repositories by Coin Metrics, which are still updated.

## Features

* The scripts build fullnodes from source, rather than by packaging official binaries
* [Nix](https://nixos.org/nix/) is used for building binaries and images
* Images are very minimal and include only necessary packages to run a fullnode (Nix closure)

## Changes to source code

Scripts use original source code downloads for building software, but may also apply additional patches.
Such patches are usually placed in `fullnodes/<specific fullnode>/patches` directories.

## Images

The images are rebuilt regularly with latest versions of dependencies. Builds are performed on Coin Metrics infrastructure.

## License

Content of this repository is made available under MIT license, see [LICENSE](LICENSE) file.
Note that this repository only contains scripts to build blockchain software from source code.
Sources of the software are distributed under their own licenses.
Please consult upstream documentation for details.

## For maintainers

### Adding new version

TODO


