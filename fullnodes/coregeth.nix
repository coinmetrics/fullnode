{ nixpkgs, version }:
rec {
  package = with nixpkgs; buildGoModule {
    pname = "coregeth";
    inherit version;
    vendorSha256 = {
      "1.11.9" = "1b6pbrlcxnj9284ia30m8x5cs6fpxbycs2dzq8p9qgar5ga9kamb";
      "1.11.10" = "1b6pbrlcxnj9284ia30m8x5cs6fpxbycs2dzq8p9qgar5ga9kamb";
      "1.11.11" = "1b6pbrlcxnj9284ia30m8x5cs6fpxbycs2dzq8p9qgar5ga9kamb";
      "1.11.12" = "1b6pbrlcxnj9284ia30m8x5cs6fpxbycs2dzq8p9qgar5ga9kamb";
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
