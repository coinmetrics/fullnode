{
  description = "Fullnodes";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs";
    };
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
    };

    allFullnodeVersions = import ./versions.nix;

    importVersion = name: version: {
      "${version}" = import (./fullnodes/${name}) { inherit pkgs version; };
    };

    allFullnodes = builtins.mapAttrs (name: versions:
      builtins.zipAttrsWith (version: bundles:
        builtins.head bundles
      ) (builtins.map (importVersion name) versions)
    ) allFullnodeVersions;

    fullnodeImage = name: version: fullnode: pkgs.dockerTools.buildLayeredImage ({
      name = "coinmetrics/${name}";
      tag = version;
      maxLayers = 2;
      created = "now";
    } // fullnode.imageConfig);

    allFullnodeImages = builtins.mapAttrs (name: versions:
      builtins.mapAttrs (fullnodeImage name) versions
    ) allFullnodes;

    allFullnodeBinaries = builtins.mapAttrs (_: versions:
      builtins.mapAttrs (_: fullnode: fullnode.package) versions
    ) allFullnodes;

    flattenAttrs = f: s: builtins.concatLists (
      pkgs.lib.mapAttrsToList (outerName: outerValue:
        pkgs.lib.mapAttrsToList (innerName: innerValue:
          { "${f outerName innerName}" = innerValue; }
        ) outerValue
      ) s
    );

    flatBinaryMap = builtins.zipAttrsWith
      (_: binaries: builtins.head binaries)
      (flattenAttrs
        (outer: inner: builtins.replaceStrings [ "." ] [ "_" ] "${outer}_${inner}")
        allFullnodeBinaries
      );

    flatImageMap = builtins.zipAttrsWith
      (_: images: builtins.head images)
      (flattenAttrs
        (outer: inner: builtins.replaceStrings [ "." ] [ "_" ] "${outer}_${inner}-image")
        allFullnodeImages
      );

    registryLoginScript = pkgs.writeShellApplication {
      name = "authenticate-to-registries";

      runtimeInputs = [ pkgs.skopeo ];

      text = ''
        skopeo login -u "$CI_REGISTRY_USER" --password-stdin "$CI_REGISTRY" <<< "$CI_REGISTRY_PASSWORD"
        skopeo login -u "$DOCKERHUB_USERNAME" --password-stdin docker.io <<< "$DOCKERHUB_TOKEN"
      '';
    };

    imagesFor = fullnode: pkgs.lib.mapAttrsToList (tag: image:
      { inherit tag image; }
    ) allFullnodeImages.${fullnode};

    publishImagesFor = fullnode:
      let
        images = imagesFor fullnode;
      in
      pkgs.writeShellApplication {
        name = "publish-${fullnode}";

        runtimeInputs = [ pkgs.skopeo ];

        text = ''
          if [[ $# -gt 0 ]] && [[ $1 == "dry-run" ]]; then
            echo "Build complete, not pushing images."
            exit 0
          fi

          images=(${builtins.concatStringsSep " " (builtins.map (i: "\"${i.image}\"") images)})
          tags=(${builtins.concatStringsSep " " (builtins.map (i: "\"${i.tag}\"") images)})

          for i in "''${!images[@]}"; do
            if [[ -n ''${CI_REGISTRY_IMAGE+x} ]]; then
              until skopeo --insecure-policy copy --retry-times 10 -f oci docker-archive:"''${images[i]}" docker://"$CI_REGISTRY_IMAGE"/${fullnode}:"''${tags[i]}"; do
                echo Copy failed, retrying in 10 seconds...
                sleep 10
              done
            fi

            if [[ $PRIVATE == "true" ]]; then
              echo "Image marked private: Skipping publish to Docker Hub."
            else
              skopeo --insecure-policy copy --retry-times 10 -f oci docker-archive:"''${images[i]}" docker://docker.io/coinmetrics/${fullnode}:"''${tags[i]}"
            fi
          done
        '';
      };
  in
  {
    packages.${system} = flatBinaryMap // flatImageMap;

    # TODO: Autogenerate
    apps.${system} = {
      login = { type = "app"; program = "${registryLoginScript}/bin/authenticate-to-registries"; };

    } // builtins.foldl' (accum: fullnode:
      accum // { "publish-${fullnode}" = { type = "app"; program = "${publishImagesFor fullnode}/bin/publish-${fullnode}"; }; }
    ) {} (builtins.attrNames allFullnodeImages);
  };
}
