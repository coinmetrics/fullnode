{ nixpkgs, version }:
rec {
  package = nixpkgs.callPackage (./. + "/dogecoin-${version}.nix") {
    withGui = false;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/dogecoind" ];
      User = "1000:1000";
    };

    extraCommands = ''
      mkdir ./bin && \
      ln -s ${nixpkgs.dash}/bin/dash ./bin/sh && \
      ln -s ${nixpkgs.gawk}/bin/awk ./bin/awk && \
      ln -s ${package}/bin/dogecoind ./bin/dogecoind && \
      ln -s ${package}/bin/dogecoin-cli ./bin/dogecoin-cli
    '';
  };
}
