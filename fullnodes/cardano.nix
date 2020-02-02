{ nixpkgs, version }:
rec {
  repo = import (builtins.fetchGit {
    url = "https://gitlab.com/coinmetrics/fullnodes/forks/cardano-sl.git";
    ref = "${version}";
  }) {};

  explorer = repo.connectScripts.mainnet.explorer;

  image = { name, tag }:
    nixpkgs.dockerTools.buildImage {
      inherit name tag;
      contents = [ nixpkgs.iana-etc ];
      config = {
        Entrypoint = [ "${explorer}" ];
        Env = [ "PATH=${nixpkgs.busybox}/bin" ];
        User = "1000:1000";
        WorkingDir = "/opt/data";
      };
    };
}
