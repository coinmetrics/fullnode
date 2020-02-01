{ nixpkgs ? import <nixpkgs> {}
, imageBaseName ? "coinmetrics/fullnode"
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
    name = imageBaseName;
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

  pushAllImagesScript = nixpkgs.writeScript "push-all-images" ''
    #!${nixpkgs.stdenv.shell} -e

    ${ builtins.concatStringsSep "" (map (image: ''
      echo 'Pushing ${imageBaseName}:${image}...'
      ${nixpkgs.skopeo}/bin/skopeo copy --dest-creds "$DOCKER_USERNAME:$DOCKER_PASSWORD" docker-archive:${allImages.${image}} docker://${imageBaseName}:${image}
    '') (builtins.attrNames allImages)) }
  '';

in rec {
  inherit images allImages allImagesList pushAllImagesScript;
  touch = { inherit pushAllImagesScript; };
}
