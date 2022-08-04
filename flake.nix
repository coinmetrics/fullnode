{
  description = "Fullnodes";

  inputs = {
    nix = {
      type = "gitlab";
      owner = "coinmetrics%2Finfrastructure";
      repo = "nix";
    };
  };

  outputs = { self, nixpkgs, nix }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      overlays = [ self.overlays.default ];
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

    flattenAttrs = f: s: builtins.concatLists (
      pkgs.lib.mapAttrsToList (outerName: outerValue:
        pkgs.lib.mapAttrsToList (innerName: innerValue:
          { "${f outerName innerName}" = innerValue; }
        ) outerValue
      ) s
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
            [[ -n ''${CI_REGISTRY_IMAGE+x} ]] && skopeo --insecure-policy copy -f oci docker-archive:"''${images[i]}" docker://"$CI_REGISTRY_IMAGE"/${fullnode}:"''${tags[i]}"
            skopeo --insecure-policy copy -f oci docker-archive:"''${images[i]}" docker://docker.io/coinmetrics/${fullnode}:"''${tags[i]}"
          done
        '';
      };
  in
  {
    overlays.default = nix.overlays.default;

    packages.${system} =
      builtins.zipAttrsWith
        (_: images: builtins.head images)
        (flattenAttrs
          (outer: inner: builtins.replaceStrings [ "." ] [ "_" ] "${outer}_${inner}")
          allFullnodeImages
        );

    # TODO: Autogenerate
    apps.${system} = {
      login = { type = "app"; program = "${registryLoginScript}/bin/authenticate-to-registries"; };

    } // builtins.foldl' (accum: fullnode:
      accum // { "publish-${fullnode}" = { type = "app"; program = "${publishImagesFor fullnode}/bin/publish-${fullnode}"; }; }
    ) {} (builtins.attrNames allFullnodeImages);
  };
}
