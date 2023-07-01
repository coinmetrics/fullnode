{ pkgs, version }:
rec {
  package = with pkgs; callPackage (./. + "/dash-${version}.nix") {
    boost = boost182;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "dashd" ];
      User = "1000:1000";
      Env = [
        "PATH=${package}/bin"
      ];
    };
  };
}
