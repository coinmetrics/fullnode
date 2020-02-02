# Unofficial fullnode images

This is unofficial fullnode images of various blockchains by Coin Metrics.

These images are being used internally at Coin Metrics, and are published in the hope they will be useful, but without any warranty.
No support is available. You are using them at your own risk.

This repository is **new**, **experimental**, and **work in progress**. If you want more stable experience, please consider the [Fullnodes](https://gitlab.com/coinmetrics/fullnodes) group of repositories by Coin Metrics, which are still updated.

Distinctive features of images:

* Built from sources, no official binaries used
* [Nix](https://nixos.org/nix/)-based
* Include very minimal set of dependencies, just enough to run the node
* Rebuilt regularly with latest versions of dependencies

All images are pushed into a single Docker Hub repository [coinmetrics/fullnode](https://hub.docker.com/r/coinmetrics/fullnode), with tags formatted `<fullnode>-<version>`.

## Fullnodes

* Cardano

## License

Content of this repository is made available under MIT license, see [LICENSE](LICENSE) file.
Note that this repository only contains scripts to build blockchain software from source code.
Sources of the software are distributed under their own licenses.
Please consult upstream documentation for details.
