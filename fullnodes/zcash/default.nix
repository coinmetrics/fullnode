{ pkgs, version }:
with pkgs; rec {
  package = callPackage (./. + "/zcash-${version}.nix") rec {
    inherit (darwin.apple_sdk.frameworks) Security;

    boost = boost182;
    db = db62;

    # Zcash calls for LLVM 15 to be used, but it is currently broken.
    # See: https://github.com/NixOS/nixpkgs/issues/214524
    llvmPackages = llvmPackages_14;
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
