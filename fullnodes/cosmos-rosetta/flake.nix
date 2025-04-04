{
  description = "Cosmos Rosetta";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    utils.url = "path:../..";
  };

  outputs = { self, flake-utils, nixpkgs, utils }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs { inherit system; };

    makeImageConfig = package: {
      config = {
        Entrypoint = [ "${package}/bin/crg" ];
        User = "1000:1000";
      };
    };

    generatedFlake = utils.lib.${system}.makeFlake {
      inherit makeImageConfig;
      name = "cosmos-rosetta";
      version = "1.0.0";
    };
  in {
    packages = generatedFlake.packages;
    apps = generatedFlake.apps // utils.lib.${system}.loginApp;
  });
}
