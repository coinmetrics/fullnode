{ nixpkgs, version }:
rec {
  src = builtins.fetchGit {
    url = "https://github.com/input-output-hk/cardano-node.git";
    ref = "refs/tags/${version}";
  };

  package = (import src {
    sourcesOverride = {
      nixpkgs = <nixpkgs>;
    };
  }).cardano-node;

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/cardano-node" ];
      User = "1000:1000";
    };
  };
}
