{ pkgs, version }:
rec {
  repo = import (builtins.fetchGit {
    url = "https://gitlab.com/coinmetrics/fullnodes/forks/cardano-sl.git";
    ref = "${version}";
  }) {};

  explorer = repo.connectScripts.mainnet.explorer;

  image = { name, tag }:
    pkgs.dockerTools.buildImage {
      inherit name tag;
      config = {
        Entrypoint = ["${explorer}"];
        User = "1000:1000";
      };
    };
}
