{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/lighthouse-${version}.nix") {
    inherit (pkgs.darwin.apple_sdk_11_0.frameworks) CoreFoundation Security SystemConfiguration;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/lighthouse" ];
      User = "1000:1000";
    };
  };
}
