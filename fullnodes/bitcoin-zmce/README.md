# Bitcoin Core update to a new version procedure

The Bitcoin node we run is a customized version (a patch applied to the official version) so whenever there's an update, a new version of the patch must be generated for that specific version.

## Useful links

[Nix image](https://gitlab.com/coinmetrics/fullnode/-/tree/master/fullnodes/bitcoin-zmce)

[Helm chart repository](https://gitlab.com/coinmetrics/ops/k8s-full-nodes/blob/master/bitcoin)

[Official repository](https://github.com/bitcoin/bitcoin)

[Our patched repository](https://gitlab.com/coinmetrics/edge/mempool-tools/bitcoin-zmq-mempool-chain-events/)

## Updating the patched version

We maintain a patched version in [this repository](https://gitlab.com/coinmetrics/edge/mempool-tools/bitcoin-zmq-mempool-chain-events/).

When a new version is released, the procedure is to:
1. checkout the new version's tag: `git checkout vXX.Z`
2. create a new branch that will contain the patched changes: `git branch vXX.Z-zmce`
3. checkout that branch: `git checkout vXX.Z-zmce`
4. cherry-pick commits from the previous patch: `git cherry-pick vXX.Y..vXX.Y-zmce`
5. build the binary and run tests: `make clean && ./autogen.sh &&  ./configure --disable-bench --disable-gui --disable-wallet && make -j8 check`
6. if compiling or tests fail, the patch needs to be updated, otherwise, the patch is ready

## Generating the Nix image

1. Add the new version to the list of versions [here](https://gitlab.com/coinmetrics/fullnode/blob/80e3293e5047301a0fe15f4835f15ea46be3756a/versions.nix#L9)
1. Copy the latest version to a new file with the new version. I.e: [bitcoin-zmce-28.0.nix](https://gitlab.com/coinmetrics/fullnode/blob/master/fullnodes/bitcoin-zmce/bitcoin-zmce-28.0.nix) -> bitcoin-zmce-28.1.nix
1. In the newly created file
    - make all the hashes zero* so they can be recomputed as explained in the [readme file](https://gitlab.com/coinmetrics/fullnode/blob/9bc33b752d479618f14f92fbee360dea78d17005/README.md) (Hopefully there's a better way to do this)

    (*) If the hash has a format and we simply make it all zeros the build will return an invalid format error. For example, the hash `sha256-cAri0eIEYC6wfyd5puZmmJO8lsDcopBZP4D/jhAv838=` is a base64 format hash so in order to make it zero we should use the following hash: 
`sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=`
    - Change the patch version (as well as all other versions) to the new one. The patch file will be created in the next steps.

1. Generate the patch file for the new version using the following command (in the patched repository): `git diff vXX.Z..vXX.Z-zmce > vXX.Z-zmce.patch`
1. Import that patch file to the `fullnode` repository in `fullnodes/bitcoin-zmce/patches`
1. commit the changes, push and create an MR and merge to master branch (no approval required for this repo)

## Deploying the updated node

2. Deploy the new node to staging:
   1. Update the fullnode version to the new version [here](https://gitlab.com/coinmetrics/ops/k8s-full-nodes/blob/283f70fe3ad743d70b0a1867c5b7491992cefae4/.gitlab-ci.yml#L127)
   1. Deploy to staging and once deployed, make sure the ZMQ messages are being generated and consumed as explained in the [wiki](https://gitlab.com/coinmetrics/wiki/-/wikis/Infrastructure/Fullnodes-list#bitcoin-zmce-patch)

