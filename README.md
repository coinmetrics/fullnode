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

#### nix-prefetch-git

This can be done using `nix-prefetch-git` for git repos which is part of nixos (this is not a binary any more and is run via nix-shell).

```
$ nix-shell -p nix-prefetch-git --run "nix-prefetch-git --rev v4.6.0 --url https://github.com/sigp/lighthouse"
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

**NOTE**: This has a **big drawback** where the github release scripts modify the source code they take from the repo before archiving in the tar.gz file, so the actual code in the repo will be different to whats in the tagged tar.gz archive and will result in different hashes as the inputs are different.

This can be seen in `src/clientversion.cpp` in the source code of [btc](https://github.com/bitcoin/bitcoin/blob/master/src/clientversion.cpp#L33) and [dgb](https://github.com/DigiByte-Core/digibyte/blob/develop/src/clientversion.cpp#L28) to name some assets. Where a #define gets inserted into the code based on a comment.


```
//! git will put "#define GIT_COMMIT_ID ..." on the next line inside archives. $Format:%n#define GIT_COMMIT_ID "%H"$

gets expanded to the following

//! git will put "#define GIT_COMMIT_ID ..." on the next line inside archives. 
#define GIT_COMMIT_ID "664c6a372bd27827cf8a3759551d61230cae0c0f"
```

An example of this in dgb, the hash based on the code in the repo

```
nix-shell -p nix-prefetch-git --run "nix-prefetch-git --rev v8.22.1 --url https://github.com/DigiByte-Core/digibyte/"
{
  "url": "https://github.com/DigiByte-Core/digibyte/",
  "rev": "664c6a372bd27827cf8a3759551d61230cae0c0f",
  "date": "2025-02-01T18:19:03-08:00",
  "path": "/nix/store/la36krzbxgh9vflx223mvijfbnh4gk15-digibyte",
  "sha256": "1qg0s9yffmxb6x9l0d2nagn82kijh6dwvkiaar7xa2l8p1na3alw",
  "hash": "sha256-nKqhbLiICtVPVirOzZuBMk6B7FNWNEBTN6tX53zS4OE=",
  "fetchLFS": false,
  "fetchSubmodules": false,
  "deepClone": false,
  "leaveDotGit": false
}
```

The tagged tar.gz archive archive can be downloaded and nix hash generated via the following command. 

```
nix-hash --type sha256 --sri digibyte/
sha256-H3mvVzHJH8jduVCCJrqBiALf6IQZBp7tZfU7bDNiy1Q=
```

Note how the hash is different to `nix-prefetch-git` due to github release scripts modify the source code. This is the same hash that will be generated by `nix-prefetch-github` and `nix-build` which download the .tar.gz code as part of the command... see the nexti section


#### nix-prefetch-github or nix-build

There is also a 3rd party lib [nix-prefetch-github](https://github.com/seppeljordan/nix-prefetch-github) which will download the .tar.gz tagged archive. Its esentially a wrapper for `nix-build` with a 0 hash specified. This approach would be used over `nix-prefetch-git` when a github release script modifies the code in the repo when producing the tagged tar.gz archive file and for supporting keepDotGit or fetchSubmodules.

```
nix-shell -p nix-prefetch-github --run "nix-prefetch-github --rev v8.22.1 DigiByte-Core digibyte"
{
    "owner": "DigiByte-Core",
    "repo": "digibyte",
    "rev": "664c6a372bd27827cf8a3759551d61230cae0c0f",
    "hash": "sha256-H3mvVzHJH8jduVCCJrqBiALf6IQZBp7tZfU7bDNiy1Q="
}
```

```
nix-build -E 'with import <nixpkgs> {}; fetchFromGitHub { owner = "DigiByte-Core"; repo = "digibyte"; rev = "refs/tags/v8.22.1"; sha256 = "0000000000000000000000000000000000000000000000000000"; }'

unpacking source archive /tmp/nix-build-source.drv-0/664c6a372bd27827cf8a3759551d61230cae0c0f.tar.gz
error: hash mismatch in fixed-output derivation '/nix/store/kksr6p9vyfm4rh7fim3w3g84jlx7xnmh-source.drv':
         specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
            got:    sha256-H3mvVzHJH8jduVCCJrqBiALf6IQZBp7tZfU7bDNiy1Q=

```
Also for `nix-build`, input `rev = "664c6a372bd27827cf8a3759551d61230cae0c0f"` can also be used instead of the tag. 

NOTE: the hash may not always be the same as for `nix-prefetch-git`


#### nix-prefetch-url
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
