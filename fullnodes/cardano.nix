{ nixpkgs, version, fork ? false }:
rec {
  repo = builtins.fetchGit {
    url = "https://github.com/input-output-hk/cardano-sl.git";
    ref = version;
  };

  src = if fork
    then nixpkgs.applyPatches {
      src = repo;
      name = "cardano-repo-forked";
      patches = [
        ./cardano/expose_inputs.patch
      ];
    }
    else repo;

  explorer = (import src {}).connectScripts.mainnet.explorer;

  imageConfig = {
    contents = [ nixpkgs.iana-etc ];
    config = {
      Entrypoint = [ "${explorer}" ];
      Env = [ "PATH=${nixpkgs.busybox}/bin" ];
      User = "1000:1000";
      WorkingDir = "/opt/data";
    };
  };
}
