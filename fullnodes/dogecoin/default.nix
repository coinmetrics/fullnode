{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/dogecoin-${version}.nix") {
    withGui = false;
    withUpnp = false;
    withUtils = false;
    withWallet = false;
    withZmq = true;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/dogecoind" ];
      User = "1000:1000";
    };

    extraCommands = ''
      mkdir ./bin && \
      ln -s ${pkgs.dash}/bin/dash ./bin/sh && \
      ln -s ${pkgs.gawk}/bin/awk ./bin/awk && \
      ln -s ${package}/bin/dogecoind ./bin/dogecoind
    '';
  };
}
