{
  description = "Decred";

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
        Entrypoint = [ "dcrd" ];
        User = "1000:1000";
        Env = [
          "PATH=${package}/bin:${pkgs.dcrctl}/bin"
        ];
      };

      contents = with pkgs.dockerTools; [
        caCertificates
      ];
    };

    generatedFlake = utils.lib.${system}.makeFlake {
      inherit makeImageConfig;
      name = "decred";
      version = "2.0.6";
    };
  in {
    packages = generatedFlake.packages;
    apps = generatedFlake.apps // utils.lib.${system}.loginApp;
  });
}
