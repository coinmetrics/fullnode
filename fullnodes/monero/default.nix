{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/monero-${version}.nix") {};

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/monerod" ];
      User = "1000:1000";
    };
  };
}
