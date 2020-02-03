{ nixpkgs, imageBaseName }:
rec {
  # all fullnodes
  fullnodes = {
    bitcoin = import ./fullnodes/bitcoin.nix;
    bitcoin-abc = import ./fullnodes/bitcoin-abc.nix;
    bitcoin-gold = import ./fullnodes/bitcoin-gold.nix;
    bitcoin-sv = import ./fullnodes/bitcoin-sv.nix;
    cardano = import ./fullnodes/cardano.nix;
  };

  # image for fullnode version
  withVersion = { fullnode, version }: nixpkgs.dockerTools.buildImage ({
    name = imageBaseName;
    tag = "${fullnode}-${version}";
  } // (fullnodes.${fullnode} {
    inherit nixpkgs version;
  }).imageConfig);

  # make a set with item per version
  withVersions = fullnode: versions:
    builtins.foldl' (m: version: m // { ${version} = withVersion { inherit fullnode version; }; }) {} versions;

  # convert set of sets of images to set of versioned images
  # { <fullnode> = { <version> = <image>; }; }   =>   { <fullnode>-<version> = <image>; }
  flattenImagesSet = let
    prependFullnode = fullnode: s: builtins.foldl' (m: n: m // { "${fullnode}-${n}" = s.${n}; }) {} (builtins.attrNames s);
    in images: builtins.foldl' (m: fullnode: m // (prependFullnode fullnode images.${fullnode})) {} (builtins.attrNames images);

  # script to push images to registry
  # depends on runtime vars DOCKER_USERNAME and DOCKER_PASSWORD
  pushImagesScript = images: nixpkgs.writeScript "push-images" ''
    #!${nixpkgs.stdenv.shell} -e

    ${ builtins.concatStringsSep "" (map (image: ''
      echo 'Pushing ${imageBaseName}:${image}...'
      ${nixpkgs.skopeo}/bin/skopeo --insecure-policy copy --dest-creds "$DOCKER_USERNAME:$DOCKER_PASSWORD" docker-archive:${images.${image}} docker://${imageBaseName}:${image}
    '') (builtins.attrNames images)) }
  '';

  # script to put images locally into docker daemon
  installImagesScript = images: nixpkgs.writeScript "install-images" ''
    #!${nixpkgs.stdenv.shell} -e

    ${ builtins.concatStringsSep "" (map (image: ''
      echo 'Installing ${imageBaseName}:${image}...'
      ${nixpkgs.skopeo}/bin/skopeo --insecure-policy copy docker-archive:${images.${image}} docker-daemon:${imageBaseName}:${image}
    '') (builtins.attrNames images)) }
  '';
}
