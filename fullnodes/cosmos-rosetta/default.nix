{ nixpkgs, version }:
rec {
  package = with nixpkgs; buildGoModule {
    pname = "cosmos-rosetta";
    inherit version;

    vendorSha256 = {
      "0.1.1" = "sha256-Pqjow1tuU8T0+p/xkBfyUoYjBjtGJ0L1LjwTIopL2x0=";
      "1.0.0" = "sha256-7/47y9o5UNBWD3Il35F4o2Ou9egEgcAQahohimkmM0A=";
    }.${version} or (builtins.trace "Cosmos Rosetta gateway: using dummy vendor SHA256" "0000000000000000000000000000000000000000000000000000");

    src = builtins.fetchGit {
      url = "https://github.com/tendermint/cosmos-rosetta-gateway.git";
      ref = "refs/tags/v${version}";
    };

    proxyVendor = true;
    doCheck = false;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/crg" ];
      User = "1000:1000";
    };
  };
}
