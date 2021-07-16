{ nixpkgs, version }:
rec {
  package = nixpkgs.callPackage (./. + "/dcrd-${version}.nix") { };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/dcrd" ];
      User = "1000:1000";
    };

    extraCommands = ''
      mkdir ./bin && \
      ln -s ${package}/bin/dcrd ./bin/dcrd && \
      mkdir -p ./etc/ssl/certs && \
      ln -s ${nixpkgs.cacert}/etc/ssl/certs/ca-bundle.crt ./etc/ssl/certs/ca-bundle.crt
    '';
  };
}
