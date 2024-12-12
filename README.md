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

## Updating versions

### General procedure

1. Add the new version to the node's versions array in `versions.nix`
2. Create a new file in the fullnodes/$node folder with the new version as suffix (`fullnodes/my-node/my-node-x.y.z.nix`)
3. Copy/paste the previous `.nix` file contents into that new file
4. Update fields to match the new version:
   - `version = ..` should be `version = 'x.y.z'`
   - Update `src.hash` to the precomputed value (see the next section for how to compute those)

#### For Golang projects

Golang projects (files containing `buildGoModule`), some extra steps are required.
The `vendorHash` field will need updating, however it cannot be pre-computed.
You need to run the build locally (or in CI) and update it with the value expected by `nix`.
If you don't have nix installed locally, you can use the CI pipeline to get the hashes computed as explained in the next section.

Don't forget to `git add` new files otherwise the nix build will fail locally.

The command to build a project is:

```
nix -L build .#my-node_x_y_z
```

### Pre-computing sources nix hash

When updating a node's version, the source's hashes need to be recomputed.

This can be done using either `nix-prefetch-git` for git repos:

```
$ nix-prefetch-git --rev v4.6.0 --url https://github.com/sigp/lighthouse
Initialized empty Git repository in /private/var/folders/rz/1m0q0l855hngpws3qwzqcync0000gn/T/git-checkout-tmp-W2giH8fN/lighthouse/.git/
remote: Enumerating objects: 1501, done.
remote: Counting objects: 100% (1501/1501), done.
remote: Compressing objects: 100% (1307/1307), done.
remote: Total 1501 (delta 148), reused 575 (delta 92), pack-reused 0
Receiving objects: 100% (1501/1501), 29.79 MiB | 25.92 MiB/s, done.
Resolving deltas: 100% (148/148), done.
From https://github.com/sigp/lighthouse
 * tag               v4.6.0     -> FETCH_HEAD
Switched to a new branch 'fetchgit'
removing `.git'...

git revision is 1be5253610dc8fee3bf4b7a8dc1d01254bc5b57d
path is /nix/store/si3xl4ngl4jfa8qv0f3c8xn9z95kg80v-lighthouse
git human-readable version is -- none --
Commit date is 2024-01-25 10:02:00 +1100
hash is 0pnybhp1j91misc866nqf6pjxz7q3z5wkxqr0cvccpfqbffxbjmq
{
  "url": "https://github.com/sigp/lighthouse",
  "rev": "1be5253610dc8fee3bf4b7a8dc1d01254bc5b57d",
  "date": "2024-01-25T10:02:00+11:00",
  "path": "/nix/store/si3xl4ngl4jfa8qv0f3c8xn9z95kg80v-lighthouse",
  "sha256": "0pnybhp1j91misc866nqf6pjxz7q3z5wkxqr0cvccpfqbffxbjmq",
  "hash": "sha256-uMrVnVvYXcY2Axn3ycsf+Pwur3HYGoOYjjUkGS5c3l4=",
  "fetchLFS": false,
  "fetchSubmodules": false,
  "deepClone": false,
  "leaveDotGit": false
}
```

Or using `nix-prefetch-url` for other resources:

```
$ nix-prefetch-url https://raw.githubusercontent.com/bitcoin-core/packaging/27.x/debian/bitcoin-qt.desktop --type sha256
path is '/nix/store/6rc7sqqgmnh91j99j3xsqlb91h4zz1gw-bitcoin-qt.desktop'
0cpna0nxcd1dw3nnzli36nf9zj28d2g9jf5y0zl9j18lvanvniha
```


### Using the CI pipeline to get the source hash

In order to get the proper source hash we need to force an error message by configuring a nonexistent hash in the new `.nix` file created for the new version as follows:
```
  src = fetchFromGitHub {
    ...
    rev = "v${version}";
    hash = "sha256-0000000000000000000000000000000000000000000=";
  };
```
Reference: https://gitlab.com/coinmetrics/fullnode/-/commit/733b00b54d6c3c170f6702bd8aaeaa27f9bd318b

Once the build job runs, it will fail and print the following error message containing the computed hash:
```
error: hash mismatch in fixed-output derivation '/nix/store/qbl4n8p64m7gww9zlckh8n3xw24a8qm0-source.drv':
         specified: sha256-0000000000000000000000000000000000000000000=
            got:    sha256-iedhLVNtwU8wSQIaq0r0fAYGH8fNnCRJW69D7wPdyx0=
```

### Using the CI pipeline to get the vendor hash

After fixing the source hash, change the vendor hash as follows to force an error that will print an error message with the correct value:
```
  vendorHash = "sha256-0000000000000000000000000000000000000000000=";
  # vendorHash = "sha256-CNwqpRx0HNvYfkowEEZe/Ue6W2FDZVAkUgof5QH9XkI=";
```
Reference: https://gitlab.com/coinmetrics/fullnode/-/commit/d04a22b9c8e26ef181a6ba9a0d5a4b92b92ae6b5

Once the build job runs, it will fail and print the following error message containing the computed hash:
```
error: hash mismatch in fixed-output derivation '/nix/store/m0lkgil9i3n16i9icq33i887k5qjg5x9-avalanchego-1.12.0-go-modules.drv':
         specified: sha256-0000000000000000000000000000000000000000000=
            got:    sha256-CNwqpRx0HNvYfkowEEZe/Ue6W2FDZVAkUgof5QH9XkI=
```


## Changes to source code

Scripts use original source code downloads for building software, but may also apply additional patches.
Such patches are usually placed in `fullnodes/<specific fullnode>/patches` directories.

### Bitcoin ZMCE

Patch files can be generated by running:

```
git diff vXX.0..vXX.0-zmce > vXX.0-zmce.patch
```

## Images

The images are rebuilt regularly with latest versions of dependencies. Builds are performed on Coin Metrics infrastructure.

## License

Content of this repository is made available under MIT license, see [LICENSE](LICENSE) file.
Note that this repository only contains scripts to build blockchain software from source code.
Sources of the software are distributed under their own licenses.
Please consult upstream documentation for details.

## For maintainers

### Adding a new fullnode

Use [this commit](https://gitlab.com/coinmetrics/fullnode/-/commit/a7f603918f31f1850b520041dee4c1bafcc81648) as a guide
for adding new fullnodes. Create a [new Docker Hub repository](https://hub.docker.com/repository/create?namespace=coinmetrics)
and assign the `bots` team `Read & Write` permissions.
