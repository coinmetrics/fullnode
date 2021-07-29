{ nixpkgs ? import <nixpkgs> {}
, imageBaseName ? "coinmetrics/fullnode"
, githubRepoBaseName ? "docker.pkg.github.com/coinmetrics/fullnode/"
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
  allImages = funcs.flattenImagesSet { inherit images; };
  # list of images
  allImagesList = builtins.attrValues allImages;
  # set of images: .<fullnode>:<version> = image
  allImagesViaColon = funcs.flattenImagesSet { inherit images; sep = ":"; };

  pushAllImagesScript = funcs.pushImagesScript { images = allImages; };
  pushAllImagesToGithubScript = funcs.pushImagesScript { images = allImagesViaColon; repoBaseName = githubRepoBaseName; };
  installAllImagesScript = funcs.installImagesScript allImages;

  dockerHubDescriptionScript = nixpkgs.writeScript "docker-hub-desc" ''
    #!${nixpkgs.stdenv.shell} -e

    ${nixpkgs.envsubst}/bin/envsubst < ${./docs/dockerhub.md.in}
    cat ${funcs.docImagesMarkdown images}
  '';
  updateDockerHubDescriptionScript = funcs.updateDockerHubDescriptionScript dockerHubDescriptionScript;

  updateDockerHubScript = nixpkgs.writeScript "update-docker-hub" ''
    #!${nixpkgs.stdenv.shell} -e

    DOCKER_USERNAME=$DOCKERHUB_USERNAME DOCKER_PASSWORD=$DOCKERHUB_TOKEN ${pushAllImagesScript}
    ${updateDockerHubDescriptionScript}
  '';

  updateGithubScript = nixpkgs.writeScript "update-github" ''
    #!${nixpkgs.stdenv.shell} -e

    DOCKER_USERNAME=$GITHUB_DOCKER_USERNAME DOCKER_PASSWORD=$GITHUB_DOCKER_TOKEN ${pushAllImagesToGithubScript}
  '';

  updateAllScript = nixpkgs.writeScript "update-all" ''
    #!${nixpkgs.stdenv.shell} -e

    ${updateDockerHubScript}
    ${updateGithubScript}
  '';

in rec {
  inherit images allImages allImagesList pushAllImagesScript pushAllImagesToGithubScript installAllImagesScript
    dockerHubDescriptionScript updateDockerHubDescriptionScript updateDockerHubScript updateGithubScript updateAllScript;
  touch = { inherit updateAllScript; };
}
