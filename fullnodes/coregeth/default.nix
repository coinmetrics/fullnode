{ nixpkgs, version }:
rec {
  package = with nixpkgs; buildGoModule {
    pname = "coregeth";
    inherit version;

    vendorSha256 = {
      "1.11.20" = "0332gw2x0lfxc8x8dnmshid0ar1sxfd3g57zp7mdaqbjib207cvb";
      "1.11.22" = "0ickqy2hlgqmjy0b8ghpw1fk7szxzgmd00hqpj1m02bknmmxss57";
      "1.12.0"  = "0fp3kv0xfh0x7sl66w6fwvmd8vs4c8ks7l72gyphv80why1l4xq7";
      "1.12.1"  = "0fp3kv0xfh0x7sl66w6fwvmd8vs4c8ks7l72gyphv80why1l4xq7";
    }.${version} or (builtins.trace "CoreGeth fullnode: using dummy vendor SHA256" "0000000000000000000000000000000000000000000000000000");

    src = builtins.fetchGit {
      url = "https://github.com/etclabscore/core-geth.git";
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
