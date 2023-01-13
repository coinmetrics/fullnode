{ pkgs, version }:
with pkgs; rec {
  package = callPackage (./. + "/zcash-${version}.nix") rec {
    boost = boost181.override { inherit stdenv; };
    db = db62.override { inherit stdenv; };
    stdenv = llvmPackages_14.libcxxStdenv;
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
