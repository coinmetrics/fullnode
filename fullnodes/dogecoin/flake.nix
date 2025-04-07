{
  description = "Dogecoin";

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

    generatedFlake = utils.lib.${system}.makeFlake {
      inherit makeImageConfig;
      name = "dogecoin";
      version = "1.14.9";
      vars = {
        boost = pkgs.boost177;
        withUpnp = false;
        withUtils = false;
        withWallet = false;
        withZmq = true;
      };
    };
  in {
    packages = generatedFlake.packages;
    apps = generatedFlake.apps // utils.lib.${system}.loginApp;
  });
}
