{
  description = "Leap";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    utils.url = "path:../..";
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

    generatedFlake = utils.lib.${system}.makeFlake {
      inherit makeImageConfig;
      name = "leap";
      version = "5.0.3";
      vars = with pkgs; {
        gcc = gcc11;
        llvm = llvmPackages_11.llvm;
      };
    };
  in {
    packages = generatedFlake.packages;
    apps = generatedFlake.apps // utils.lib.${system}.loginApp;
  });
}
