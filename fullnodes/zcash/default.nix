{ pkgs, version }:
with pkgs; rec {
  package = callPackage (./. + "/zcash-${version}.nix") rec {
    inherit (darwin.apple_sdk.frameworks) Security;

    boost = boost183;
    db = db62;
    llvmPackages = llvmPackages_15;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/zcashd" ];
      User = "1000:1000";
    };

    extraCommands = ''
      mkdir ./bin && \
      ln -s ${pkgs.dash}/bin/dash ./bin/sh && \
      ln -s ${pkgs.gawk}/bin/awk ./bin/awk && \
      ln -s ${package}/bin/zcashd ./bin/zcashd && \
      ln -s ${package}/bin/zcash-cli ./bin/zcash-cli
    '';
  };
}
