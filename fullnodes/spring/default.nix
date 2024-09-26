{ pkgs, version }:
with pkgs; rec {
  package = callPackage (./. + "/spring-${version}.nix") {
    gcc = gcc11;
    llvm = llvmPackages_11.llvm;
  };

  contents = [
    coreutils
    findutils
    gdb
    gnugrep
    procps
    util-linux
  ];

  imageConfig = {
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
}
