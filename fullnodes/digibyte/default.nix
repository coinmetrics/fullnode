{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/digibyte-${version}.nix") {
    withGui = false;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/digibyted" ];
      User = "1000:1000";
    };

    extraCommands = ''
      mkdir ./bin && \
      ln -s ${package}/bin/digibyted ./bin/digibyted
    '';
  };
}
