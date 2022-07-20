{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/litecoin-${version}.nix") {};

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/litecoind" ];
      User = "1000:1000";
    };
  };
}
