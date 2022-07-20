{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/bitcoin-${version}.nix") {};

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/bitcoind" ];
      User = "1000:1000";
    };
  };
}
