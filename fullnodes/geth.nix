{ nixpkgs, version }:
rec {
  package = with nixpkgs; buildGoModule {
    pname = "geth";
    inherit version;
    vendorSha256 = {
      "1.9.19" = "1744df059bjksvih4653nnvb4kb1xvzdhypd0nnz36m1wrihqssv";
      "1.9.20" = "1744df059bjksvih4653nnvb4kb1xvzdhypd0nnz36m1wrihqssv";
    }.${version} or (builtins.trace "Geth fullnode: using dummy vendor SHA256" "0000000000000000000000000000000000000000000000000000");
    src = builtins.fetchGit {
      url = "https://github.com/ethereum/go-ethereum.git";
      ref = "refs/tags/v${version}";
    };

    runVend = true;

    doCheck = false;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/geth" ];
      User = "1000:1000";
    };
  };
}
