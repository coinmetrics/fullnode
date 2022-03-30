{ nixpkgs, version }:
rec {
  package = with nixpkgs; buildGoModule {
    pname = "geth";
    inherit version;

    vendorSha256 = {
      "1.10.14" = "sha256-2H2+i+LweJ3Ip1NUFX/d54wD4ukstZDdhXQydFXUlZM=";
      "1.10.15" = "sha256-2H2+i+LweJ3Ip1NUFX/d54wD4ukstZDdhXQydFXUlZM=";
      "1.10.16" = "sha256-gb7CB/Bzn/kJKV36WatrJc9yjsNcQByCtt3xnfyEreE=";
      "1.10.17" = "sha256-KlZTqKjAkkLYcEUAKEmNKpS19P29DzIXTuDK8vhB+20=";
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
