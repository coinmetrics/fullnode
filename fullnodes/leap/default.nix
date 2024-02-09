{ pkgs, version }:
with pkgs; rec {
  package = callPackage (./. + "/leap-${version}.nix") {
    gcc = gcc11;
    llvm = llvm_11;
  };

  contents = [
    package.debug
  ];

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/nodeos" ];
      User = "1000:1000";
    };

    extraCommands = ''
      mkdir ./bin && \
      ln -s ${package}/bin/nodeos ./bin/nodeos && \
      ln -s ${package}/bin/leap-util ./bin/leap-util && \
      ln -s ${bashInteractive}/bin/bash ./bin/bash && \
      ln -s ${gdb}/bin/gdb ./bin/gdb && \
      ln -s ${procps}/bin/ps ./bin/ps
    '';
  };
}
