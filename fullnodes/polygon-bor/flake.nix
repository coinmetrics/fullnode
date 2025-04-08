{
  description = "Polygon Bor";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/b48adff7284b30a4d63bcbf0534c7eddcc0c60b7";
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
        Entrypoint = [ "${package}/bin/bor" ];
        User = "1000:1000";
      };
    };

    generatedFlake = utils.lib.${system}.makeFlake {
      inherit makeImageConfig;
      name = "polygon-bor";
      version = "1.4.0";
    };
  in {
    packages = generatedFlake.packages;
    apps = generatedFlake.apps // utils.lib.${system}.loginApp;
  });
}
