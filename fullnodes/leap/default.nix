{ pkgs, version }:
with pkgs; rec {
  package = callPackage (./. + "/leap-${version}.nix") {
    llvm = llvm_11;
    llvmPackages = llvmPackages_17;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/nodeos" ];
      User = "1000:1000";
    };

    extraCommands = ''
      mkdir ./bin && \
      ln -s ${package}/bin/nodeos ./bin/nodeos && \
      ln -s ${package}/bin/leap-util ./bin/leap-util
    '';
  };
}
