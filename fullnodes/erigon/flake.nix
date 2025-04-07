{
  description = "Erigon";

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
        Entrypoint = [ "${package}/bin/erigon" ];
        User = "1000:1000";
      };
    };

    generatedFlake = utils.lib.${system}.makeFlake {
      inherit makeImageConfig;
      name = "erigon";
      version = "2.60.8";
      vars = {
        boost = pkgs.boost181;
        llvmPackages = pkgs.llvmPackages_17;
      };
    };
  in {
    packages = generatedFlake.packages;
    apps = generatedFlake.apps // utils.lib.${system}.loginApp;
  });
}
