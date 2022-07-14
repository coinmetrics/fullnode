{ nixpkgs, version }:
rec {
  package = with nixpkgs; buildGoModule {
    pname = "geth";
    inherit version;

    vendorSha256 = {
      "1.10.19" = "sha256-MZCX0Io7dMVas1YDjPli98MdheG3J18g5UYAVCIii3k=";
      "1.10.20" = "sha256-MZCX0Io7dMVas1YDjPli98MdheG3J18g5UYAVCIii3k=";
    }.${version} or (builtins.trace "Geth fullnode: using dummy vendor SHA256" "0000000000000000000000000000000000000000000000000000");

    src = builtins.fetchGit {
      url = "https://github.com/ethereum/go-ethereum.git";
      ref = "refs/tags/v${version}";
    };

    proxyVendor = true;
    doCheck = false;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/geth" ];
      User = "1000:1000";
    };
  };
}
