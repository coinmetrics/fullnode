{
  description = "Dash";

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
        Entrypoint = [ "dashd" ];
        User = "1000:1000";
        Env = [
          "PATH=${package}/bin"
        ];
      };
    };

    generatedFlake = utils.lib.${system}.makeFlake {
      inherit makeImageConfig;
      name = "dash";
      version = "22.0.0";
      vars = {
        boost = pkgs.boost182;
      };
    };
  in {
    packages = generatedFlake.packages;
    apps = generatedFlake.apps // utils.lib.${system}.loginApp;
  });
}
