#!/bin/sh
set -x

VERSION="${1:?version}"

wget -O ./Cargo-${VERSION}.lock https://raw.githubusercontent.com/paritytech/polkadot/v${VERSION}/Cargo.lock
git add ./Cargo-${VERSION}.lock

sed "s/VERSION/$VERSION/" polkadot-template.nix > polkadot-${VERSION}.nix
git add polkadot-${VERSION}.nix

