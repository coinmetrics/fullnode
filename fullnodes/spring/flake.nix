{
  description = "Spring";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/0b369088d7534278bd67cf848fe30b786895faf3";
    utils = {
      url = "path:../..";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, flake-utils, nixpkgs, utils }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs { inherit system; };

    makeImageConfig = with pkgs; package: {
      config = {
        Entrypoint = [ "${package}/bin/nodeos" ];
        User = "1000:1000";
        Env = [
          "NIX_DEBUG_INFO_DIRS=${package.debug}/lib/debug"
          "PATH=${lib.concatStringsSep ":" [
            "${coreutils}/bin"
            "${findutils}/bin"
            "${gdb}/bin"
            "${gnugrep}/bin"
            "${package}/bin"
            "${procps}/bin"
            "${util-linux}/bin"
            "/bin"
          ]}"
        ];
      };

      extraCommands = ''
        mkdir ./bin && \
        ln -s ${bashInteractive}/bin/bash ./bin/bash
      '';
    };

    generatedFlake = with pkgs; utils.lib.${system}.makeFlake {
      inherit makeImageConfig;
      name = "spring";
      version = "1.1.2";
      vars = {
        gcc = gcc11;
        llvm = llvmPackages_11.llvm;
      };
    };
  in {
    packages = generatedFlake.packages;
    apps = generatedFlake.apps // utils.lib.${system}.loginApp;
  });
}
