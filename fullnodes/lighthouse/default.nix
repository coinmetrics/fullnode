{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/lighthouse-${version}.nix") {
    inherit (pkgs.darwin.apple_sdk.frameworks) Security;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/lighthouse" ];
      User = "1000:1000";
    };
  };
}
