{
  description = "Openethereum";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/215d4d0fd80ca5163643b03a33fde804a29cc1e2";
    utils = {
      url = "path:../..";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, flake-utils, nixpkgs, utils }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs { inherit system; };

    makeImageConfig = package: {
      config = {
        Entrypoint = [ "${package}/bin/openethereum" ];
        User = "1000:1000";
      };

      extraCommands = ''
        mkdir ./bin && \
        ln -s ${pkgs.dash}/bin/dash ./bin/sh && \
        ln -s ${pkgs.gawk}/bin/awk ./bin/awk && \
        ln -s ${package}/bin/openethereum ./bin/openethereum
      '';
    };

    generatedFlake = utils.lib.${system}.makeFlake {
      inherit makeImageConfig;
      name = "openethereum";
      version = "3.3.5";
      vars = {
        stdenv = pkgs.llvmPackages_12.stdenv;
      };
    };
  in {
    packages = generatedFlake.packages;
    apps = generatedFlake.apps // utils.lib.${system}.loginApp;
  });
}
