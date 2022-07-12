{ nixpkgs, version }:
rec {
  package = nixpkgs.callPackage (./. + "/bitcoin-gold-${version}.nix") {
    withGui = false;
    withWallet = false;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/bgoldd" ];
      User = "1000:1000";
    };

    extraCommands = ''
      mkdir ./bin && \
      ln -s ${package}/bin/bgoldd ./bin/bgoldd
    '';
  };
}
