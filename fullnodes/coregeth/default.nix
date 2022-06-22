{ nixpkgs, version }:
rec {
  package = with nixpkgs; buildGoModule {
    pname = "coregeth";
    inherit version;

    vendorSha256 = {
      "1.12.3"  = "sha256-dq+wMw3sZ3G5ESq8esU5VX4mZFyZdMLFDkx9Qanz8os=";
      "1.12.4"  = "sha256-dq+wMw3sZ3G5ESq8esU5VX4mZFyZdMLFDkx9Qanz8os=";
      "1.12.6"  = "sha256-dq+wMw3sZ3G5ESq8esU5VX4mZFyZdMLFDkx9Qanz8os=";
      "1.12.7"  = "sha256-xvAgMwkO/sVrwk9SCwIXhgttntzmEY6HCi1dM3PJ35Q=";
    }.${version} or (builtins.trace "CoreGeth fullnode: using dummy vendor SHA256" "0000000000000000000000000000000000000000000000000000");

    src = builtins.fetchGit {
      url = "https://github.com/etclabscore/core-geth.git";
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
