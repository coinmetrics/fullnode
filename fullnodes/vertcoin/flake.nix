{
  description = "Vertcoin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
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
        Entrypoint = [ "${package}/bin/vertcoind" ];
        User = "1000:1000";
      };
    };

    generatedFlake = utils.lib.${system}.makeFlake {
      inherit makeImageConfig;
      name = "vertcoin";
      version = "23.2";
    };
  in {
    packages = generatedFlake.packages;
    apps = generatedFlake.apps // utils.lib.${system}.loginApp;
  });
}
