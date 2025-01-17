# Bitcoin Core update to a new version procedure:

Nix image: https://gitlab.com/coinmetrics/fullnode/-/tree/master/fullnodes/bitcoin-zmce

Helm chart repository: https://gitlab.com/coinmetrics/ops/k8s-full-nodes/blob/master/bitcoin

Official repository: https://github.com/bitcoin/bitcoin

Bitcoin node is a customized version (a patch applied to the official version) so whenever there's an update, a new version of the patch must be generated for that specific version.


Before starting:
- Get the current version:
It seems that the current version being deployed is configured in the gitlab CI file here: https://gitlab.com/coinmetrics/ops/k8s-full-nodes/blob/283f70fe3ad743d70b0a1867c5b7491992cefae4/.gitlab-ci.yml#L127

A different version can be configured for each deployment. Additionally, the container images can be found here: https://gitlab.com/coinmetrics/fullnode/container_registry/3266559

- Get the current version being released from the official repository: https://github.com/bitcoin/bitcoin/releases/tag/v28.1 (this link should come from the infra ticket assigned to you)

In theory, the current version in production should be the latest Nix image version.


1. Generate the new Nix image
    1. Add the new version to the list of versions here: https://gitlab.com/coinmetrics/fullnode/blob/80e3293e5047301a0fe15f4835f15ea46be3756a/versions.nix#L9
    1. Copy the latest version to a new file with the new version. I.e: https://gitlab.com/coinmetrics/fullnode/blob/master/fullnodes/bitcoin-zmce/bitcoin-zmce-28.0.nix -> bitcoin-zmce-28.1.nix
    1. In the newly created file
          - make all the hashes zero* so they can be recomputed as explained in the readme file here: https://gitlab.com/coinmetrics/fullnode/blob/9bc33b752d479618f14f92fbee360dea78d17005/README.md (Hopefully there's a better way to do this)

          (*) If the hash has a format and we simply make it all zeros the build will return an invalid format error. For example, the hash `sha256-cAri0eIEYC6wfyd5puZmmJO8lsDcopBZP4D/jhAv838=` is a base64 format hash so in order to make it zero we should use the following hash: 
`sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=`
          - Change the patch version (as well as all other versions) to the new one. The patch file will be created in the next steps.

    1. Generate the patch file for the new version using the following commands, commit the changes, push and create an MR and merge to master branch (no approval required for this repo):

Assuming that the Nix images repo is located under `$HOME/git/fullnodes` and that the current version is 28.0 and the new version is 28.1, the following commands can be executed to generate the patch file for the new version:
```
export NIX_REPO=$HOME/git/fullnode/fullnodes/bitcoin-zmce

cd /tmp

git clone https://github.com/bitcoin/bitcoin.git
cd bitcoin
git checkout v28.0

patch -p1 < $NIX_REPO/patches/v28.0-zmce.patch

git checkout -b zmce_branch

git add .

git commit -a -m "Zmce changes from patch"

git merge v28.1

git tag v28.1-zmce

git diff v28.1..v28.1-zmce > $NIX_REPO/patches/v28.1-zmce.patch

cd -
```


2. Deploy the new node to staging:
   1. Update the fullnode version to the new version here: https://gitlab.com/coinmetrics/ops/k8s-full-nodes/blob/283f70fe3ad743d70b0a1867c5b7491992cefae4/.gitlab-ci.yml#L127
   1. Deploy to staging and once deployed, make sure the ZMQ messages are being generated and consumed as explained in the wiki here: https://gitlab.com/coinmetrics/wiki/-/wikis/Infrastructure/Fullnodes-list#bitcoin-zmce-patch

