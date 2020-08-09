# Unofficial fullnode images

This repo contains scripts to build fullnode images of various blockchains by Coin Metrics.

These images are being used internally at Coin Metrics, and are published in the hope they will be useful, but without any warranty.
No support is available. You are using them at your own risk.

This repository is **new**, **experimental**, and **work in progress**. If you want more stable experience, please consider the [Fullnodes](https://gitlab.com/coinmetrics/fullnodes) group of repositories by Coin Metrics, which are still updated.

## Features

* The scripts build fullnodes from source, rather than by packaging official binaries
* [Nix](https://nixos.org/nix/) is used for building binaries and images
* Images are very minimal and include only necessary packages to run a fullnode (Nix closure)

## Changes to source code

Scripts use original source code downloads for building software, but may also apply additional patches to fix known issues in blockchain software in a backward-compatible way, before new official release is made.
Such patches are placed in `fullnodes/<specific fullnode>` directories.

Coin Metrics also maintains patches which may break compatibility with vanilla fullnodes, adding features necessary for Coin Metrics purposes. Docker images built with use of those patches contain `cmfork` in their image tag, to differentiate from vanilla images. Patches are placed in the same directories.

## Images

All images are pushed into a single Docker Hub repository [coinmetrics/fullnode](https://hub.docker.com/r/coinmetrics/fullnode), with tags formatted `<fullnode>-<version>`.

The images are rebuilt regularly with latest versions of dependencies. Builds are performed on Coin Metrics infrastructure.

## Fullnodes

* Bitcoin
* Bitcoin ABC
* Bitcoin Gold
* Bitcoin SV
* Bitcoin ZMCE (CoinMetrics fork)
* CoreGeth
* Elements
* Ethereum
* Grin
* Litecoin
* Monero
* OmniCore
* PIVX
* Ripple
* Vertcoin

## License

Content of this repository is made available under MIT license, see [LICENSE](LICENSE) file.
Note that this repository only contains scripts to build blockchain software from source code.
Sources of the software are distributed under their own licenses.
Please consult upstream documentation for details.

## For maintainers

### Adding new version

For most of the fullnodes it is enough to add an appropriate line to `versions.nix`.

Some fullnodes are special cases.

* Rust-based nodes (Ethereum): due to a sad state of Rust support in Nix, hashes of resulting packages must be hardcoded into corresponding `.nix` file, per version, for `cargoSha256` argument. [The official way to calculate hash](https://nixos.org/nixpkgs/manual/#compiling-rust-applications-with-cargo) is to try to compile it with fake hash, and then take the correct hash from error message in the build log.
