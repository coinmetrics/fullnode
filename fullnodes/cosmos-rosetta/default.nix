{ nixpkgs, version }:
rec {
  package = with nixpkgs; buildGoModule {
    pname = "cosmos-rosetta";
    inherit version;

    vendorSha256 = {
      "0.1.0" = "12qrqlk2x674as07whhh23ga4qj43fz0636fvh6i9xbndabfpp1z";
      "0.1.1" = "0z4njrqya5lr7h07idqx195wnafs83ix0s5hm6kbax3sg6rxpzdq";
      "0.2.0" = "0mm9vvcjcvps3iklhszmpf7f903x816ma4r4sb3q9risa6wirgpa";
    }.${version} or (builtins.trace "Cosmos Rosetta gateway: using dummy vendor SHA256" "0000000000000000000000000000000000000000000000000000");

    src = builtins.fetchGit {
      url = "https://github.com/tendermint/cosmos-rosetta-gateway.git";
      ref = "refs/tags/v${version}";
    };

    runVend = true;
    doCheck = false;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/crg" ];
      User = "1000:1000";
    };
  };
}
