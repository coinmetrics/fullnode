{
  description = "Fullnodes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs { inherit system; };
  in {
    lib = rec {
      registryLoginScript = pkgs.writeShellApplication {
        name = "authenticate-to-registries";

        runtimeInputs = [ pkgs.skopeo ];

        text = ''
          skopeo login -u "$CI_REGISTRY_USER" --password-stdin "$CI_REGISTRY" <<< "$CI_REGISTRY_PASSWORD"
          skopeo login -u "$DOCKERHUB_USERNAME" --password-stdin docker.io <<< "$DOCKERHUB_TOKEN"
        '';
      };

      publishScript = name: version: image: pkgs.writeShellApplication {
        name = "publish";

        runtimeInputs = [ pkgs.skopeo ];

        text = ''
          if [[ -n ''${CI_REGISTRY_IMAGE+x} ]]; then
            until skopeo --insecure-policy copy --retry-times 10 -f oci docker-archive:"${image}" docker://"$CI_REGISTRY_IMAGE"/${name}:${version}; do
              echo Copy failed, retrying in 10 seconds...
              sleep 10
            done
          fi

          if [[ $PRIVATE == "true" ]]; then
            echo "Image marked private: Skipping publish to Docker Hub."
          else
            skopeo --insecure-policy copy --retry-times 10 -f oci docker-archive:"${image}" docker://docker.io/coinmetrics/${name}:${version}
          fi
        '';
      };

      loginApp = {
        login = {
          type = "app";
          program = "${registryLoginScript}/bin/authenticate-to-registries";
        };
      };

      makeFlake = { name, version, vars ? {}, makeImageConfig }:
        let
          normalizedName = builtins.replaceStrings [ "." ] [ "_" ] "${name}-${version}";
        in rec {
          packages = {
            ${normalizedName} = pkgs.callPackage (./. + "/fullnodes/${name}/${name}-${version}.nix") vars;
            "${normalizedName}-image" = pkgs.dockerTools.buildLayeredImage ({
              name = "${name}-${version}";
              tag = version;
              maxLayers = 2;
              created = "now";
            } // makeImageConfig packages.${normalizedName});
          };

          apps = {
            "${normalizedName}-publish" = {
              type = "app";
              program = "${publishScript name version packages."${normalizedName}-image"}/bin/publish";
            };
          };
        };
    };
  });
}
