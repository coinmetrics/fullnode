{ nixpkgs ? import <nixpkgs> {}
}:
let
  fullnodes = {
    cardano = import ./fullnodes/cardano.nix;
  };

  # image for fullnode version
  withVersion = { fullnode, version }: (fullnodes.${fullnode} {
    pkgs = nixpkgs;
    inherit version;
  }).image {
    name = "coinmetrics/fullnode";
    tag = "${fullnode}-${version}";
  };

  # make a set with item per version
  withVersions = fullnode: versions:
    builtins.foldl' (m: version: m // { ${version} = withVersion { inherit fullnode version; }; }) {} versions;

  # versions to build
  fullnodeVersions = import ./versions.nix;

  images = builtins.foldl'
    (m: fullnode: m // { ${fullnode} = withVersions fullnode fullnodeVersions.${fullnode}; })
    {} (builtins.attrNames fullnodeVersions);

  prependFullnode = fullnode: s: builtins.foldl' (m: n: m // { "${fullnode}-${n}" = s.${n}; }) {} (builtins.attrNames s);

  allImages = builtins.foldl' (m: fullnode: m // (prependFullnode fullnode images.${fullnode})) {} (builtins.attrNames images);

  allImagesList = builtins.attrValues allImages;

in rec {
  inherit images allImages allImagesList;
  touch = allImages;
}
