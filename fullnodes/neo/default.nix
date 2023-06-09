{ pkgs, version }:
with pkgs; rec {
  package = callPackage (./. + "/neo-${version}.nix") rec { };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/neo-cli" ];
      User = "0:0";
    };

    # /tmp is needed by the .NET runtime
    fakeRootCommands = ''
      mkdir ./tmp
    '';
  };
}
