{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/polkadot-${version}.nix") { };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/polkadot" ];
      User = "1000:1000";
    };
  };
}
