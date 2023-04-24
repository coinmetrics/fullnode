{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/avalanchego-${version}.nix") {
    inherit (pkgs.darwin.apple_sdk.frameworks) IOKit;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/avalanchego" ];
      User = "1000:1000";
    };
  };
}
