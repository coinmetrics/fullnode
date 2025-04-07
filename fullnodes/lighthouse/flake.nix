{
  description = "Lighthouse";

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
        Entrypoint = [ "${package}/bin/lighthouse" ];
        User = "1000:1000";
        Env = [ "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" ];
      };
    };

    generatedFlake = utils.lib.${system}.makeFlake {
      inherit makeImageConfig;
      name = "lighthouse";
      version = "6.0.1";
      vars = {
        inherit (pkgs.darwin.apple_sdk_11_0.frameworks) CoreFoundation Security SystemConfiguration;
      };
    };
  in {
    packages = generatedFlake.packages;
    apps = generatedFlake.apps // utils.lib.${system}.loginApp;
  });
}
