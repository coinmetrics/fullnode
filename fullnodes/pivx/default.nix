{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/pivx-${version}.nix") {};

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/pivxd" "-paramsdir=${package}/share/pivx" ];
      User = "1000:1000";
    };
  };
}
