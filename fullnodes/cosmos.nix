{ nixpkgs, version }:
rec {
  package = with nixpkgs; buildGoModule {
    pname = "cosmos";
    inherit version;
    vendorSha256 = {
      "2.0.13" = "1d08jx6wv8wr48lk9lwv2rs8ax6dcd1vs30bbhdp2yc104j2cyk8";
    }.${version} or (builtins.trace "Cosmos fullnode: using dummy vendor SHA256" "0000000000000000000000000000000000000000000000000000");
    src = builtins.fetchGit {
      url = "https://github.com/cosmos/gaia.git";
      ref = "refs/tags/v${version}";
    };

    runVend = true;

    doCheck = false;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/gaiad" ];
      User = "1000:1000";
    };
  };
}
