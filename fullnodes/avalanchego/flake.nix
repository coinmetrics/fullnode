{
  description = "Avalanche Go";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self, flake-utils, nixpkgs }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs { inherit system; };
    fullnode = import ./default.nix { inherit pkgs; version = "1.13.0"; };

    image = pkgs.dockerTools.buildLayeredImage ({
      name = "coinmetrics/avalanchego";
      tag = "1.13.0";
      maxLayers = 2;
      created = "now";
    } // fullnode.imageConfig);

    registryLoginScript = pkgs.writeShellApplication {
      name = "authenticate-to-registries";

      runtimeInputs = [ pkgs.skopeo ];

      text = ''
        skopeo login -u "$CI_REGISTRY_USER" --password-stdin "$CI_REGISTRY" <<< "$CI_REGISTRY_PASSWORD"
        skopeo login -u "$DOCKERHUB_USERNAME" --password-stdin docker.io <<< "$DOCKERHUB_TOKEN"
      '';
    };
    publishScript = pkgs.writeShellApplication {
      name = "publish";

      runtimeInputs = [ pkgs.skopeo ];

      text = ''
        if [[ -n ''${CI_REGISTRY_IMAGE+x} ]]; then
          until skopeo --insecure-policy copy --retry-times 10 -f oci docker-archive:"${image}" docker://"$CI_REGISTRY_IMAGE"/avalanchego:1.13.0; do
            echo Copy failed, retrying in 10 seconds...
            sleep 10
          done
        fi

        skopeo --insecure-policy copy --retry-times 10 -f oci docker-archive:"${image}" docker://docker.io/coinmetrics/avalanchego:1.13.0
      '';
    };
  in {
    packages.v1_13_0 = fullnode.package;
    apps = {
      login = { type = "app"; program = "${registryLoginScript}/bin/authenticate-to-registries"; };
      publish = {
        type = "app";
        program = "${publishScript}/bin/publish";
      };
    };
  });
}
