{ nixpkgs, imageBaseName }:
rec {
  # all fullnodes
  fullnodes = {
    bitcoin = import ./fullnodes/bitcoin;
    bitcoin-abc = import ./fullnodes/bitcoin-abc;
    bitcoin-cash-node = import ./fullnodes/bitcoin-cash-node;
    bitcoin-gold = import ./fullnodes/bitcoin-gold;
    bitcoin-sv = import ./fullnodes/bitcoin-sv;
    bitcoin-zmce = import ./fullnodes/bitcoin-zmce;
    coregeth = import ./fullnodes/coregeth;
    cosmos = import ./fullnodes/cosmos;
    cosmos-rosetta = import ./fullnodes/cosmos-rosetta;
    decred = import ./fullnodes/decred;
    elements = import ./fullnodes/elements;
    openethereum = import ./fullnodes/openethereum;
    geth = import ./fullnodes/geth;
    grin = import ./fullnodes/grin;
    litecoin = import ./fullnodes/litecoin;
    monero = import ./fullnodes/monero;
    neo-go = import ./fullnodes/neo-go;
    omnicore = import ./fullnodes/omnicore;
    pivx = import ./fullnodes/pivx;
    ripple = import ./fullnodes/ripple;
    vertcoin = import ./fullnodes/vertcoin;
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
    builtins.foldl' (m: version: m // { ${version} = withVersion { inherit fullnode version; }; }) {
      latest = withVersion {
        inherit fullnode;
        version = nixpkgs.lib.last versions;
      };
    } versions;

  # convert set of sets of images to set of versioned images
  # { <fullnode> = { <version> = <image>; }; }   =>   { <fullnode>-<version> = <image>; }
  flattenImagesSet = { sep ? "-", images }: let
    prependFullnode = fullnode: s: builtins.foldl' (m: n: m // { "${fullnode}${sep}${n}" = s.${n}; }) {} (builtins.attrNames s);
    in builtins.foldl' (m: fullnode: m // (prependFullnode fullnode images.${fullnode})) {} (builtins.attrNames images);

  # script to push images to registry
  # depends on runtime vars DOCKER_USERNAME and DOCKER_PASSWORD
  pushImagesScript = { images, repoBaseName ? "${imageBaseName}:" }: nixpkgs.writeScript "push-images" ''
    #!${nixpkgs.stdenv.shell} -e

    ${ builtins.concatStringsSep "" (map (image: ''
      echo 'Pushing ${repoBaseName}${image}...'
      ${nixpkgs.skopeo}/bin/skopeo --insecure-policy copy --dest-creds "$DOCKER_USERNAME:$DOCKER_PASSWORD" docker-archive:${images.${image}} docker://${repoBaseName}${image}
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

  docImagesMarkdown = images: nixpkgs.writeText "docImagesMarkdown" ''
    ${ builtins.concatStringsSep "" (nixpkgs.lib.mapAttrsToList (fullnode: imagesByVersion: let
      # [ { image = version; }... ]
      versionsWithImage = nixpkgs.lib.mapAttrsToList (version: image: { ${builtins.unsafeDiscardStringContext image} = version; }) imagesByVersion;
      # [ [ version... ]... ]
      versionGroups =
        builtins.sort (v1: v2: builtins.compareVersions (nixpkgs.lib.last v1) (nixpkgs.lib.last v2) > 0)
        (nixpkgs.lib.mapAttrsToList
          (image: versions: builtins.sort (v1: v2: builtins.compareVersions v1 v2 < 0) versions)
          (nixpkgs.lib.foldAttrs (e: l: [e] ++ l) [] versionsWithImage)
        );

    in ''
      **${fullnode}**: ${ builtins.concatStringsSep "; " (map (versions: builtins.concatStringsSep " = " (map (version: "`${fullnode}-${version}`") versions)) versionGroups) }

    '') images) }
  '';

  updateDockerHubDescriptionScript = descriptionScript: nixpkgs.writeScript "update-docker-hub-desc" ''
    #!${nixpkgs.stdenv.shell} -e

    echo 'Logging into Docker Hub...'
    TOKEN=$(${nixpkgs.curl}/bin/curl --fail -H 'Content-Type: application/json' \
      -d "{\"username\":\"''${DOCKERHUB_USERNAME}\",\"password\":\"''${DOCKERHUB_PASSWORD}\"}" \
      https://hub.docker.com/v2/users/login/ | ${nixpkgs.jq}/bin/jq -r .token)

    echo 'Updating ${imageBaseName} description...'
    ${nixpkgs.curl}/bin/curl --fail -H "Authorization: JWT ''${TOKEN}" \
      -X PATCH --data-urlencode full_description@<(${descriptionScript}) \
      https://hub.docker.com/v2/repositories/${imageBaseName}/
  '';
}
