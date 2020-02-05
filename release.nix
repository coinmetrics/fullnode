{ nixpkgs ? import <nixpkgs> {}
, imageBaseName ? "coinmetrics/fullnode"
}:
let
  funcs = import ./default.nix {
    inherit nixpkgs imageBaseName;
  };

  # versions to build
  fullnodeVersions = import ./versions.nix;

  # set of sets: .<fullnode>.<version> = image
  images = builtins.foldl'
    (m: fullnode: m // { ${fullnode} = funcs.withVersions fullnode fullnodeVersions.${fullnode}; })
    {} (builtins.attrNames fullnodeVersions);

  # set of images: .<fullnode>-<version> = image
  allImages = funcs.flattenImagesSet images;
  # list of images
  allImagesList = builtins.attrValues allImages;

  pushAllImagesScript = funcs.pushImagesScript allImages;
  installAllImagesScript = funcs.installImagesScript allImages;

  dockerHubDescription = nixpkgs.writeText "docker-hub-desc.md"
    "${builtins.readFile ./docs/dockerhub.md.in}${builtins.readFile (funcs.docImagesMarkdown images)}";
  updateDockerHubDescriptionScript = funcs.updateDockerHubDescriptionScript dockerHubDescription;

  updateDockerHubScript = nixpkgs.writeScript "update-docker-hub" ''
    #!${nixpkgs.stdenv.shell} -e

    ${pushAllImagesScript}
    ${updateDockerHubDescriptionScript}
  '';

in rec {
  inherit images allImages allImagesList pushAllImagesScript installAllImagesScript
    dockerHubDescription updateDockerHubDescriptionScript updateDockerHubScript;
  touch = { inherit updateDockerHubScript; };
}
