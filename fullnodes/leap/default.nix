{ pkgs, version }:
with pkgs; rec {
  package = callPackage (./. + "/leap-${version}.nix") {
    gcc = gcc11;
    llvm = llvm_11;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/nodeos" ];
      User = "1000:1000";
    };

    extraCommands = ''
      mkdir ./bin && \
      ln -s ${package}/bin/nodeos ./bin/nodeos && \
      ln -s ${package}/bin/leap-util ./bin/leap-util && \
      ln -s ${gdb}/bin/gdb ./bin/gdb
    '';
  };
}
