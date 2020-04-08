{ nixpkgs, version }:
with nixpkgs; rec {
  package = {
    "1.4.0" = callPackage ./ripple/ripple-1.4.0.nix {
      boost = boost171;
    };
  }.${version};

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/rippled" "--fg" ];
      User = "1000:1000";
    };
    contents = [ cacert ];
  };
}
