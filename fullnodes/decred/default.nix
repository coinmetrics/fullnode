{ nixpkgs, version }:
rec {
  package = with nixpkgs; buildGoModule {
    pname = "decred";
    inherit version;

    vendorSha256 = {
      "1.5.2" = "0f02ip0rprhfd04ifbin8zvacpyzj8gzy5vfvlh2a965a4fn78fk";
      "1.6.0" = "0jjz4n1bdd0r86pf8dxqdah1hsqwmckasqlh9i6zzm9qz9ncc4i7";
      "1.6.1" = "0jjz4n1bdd0r86pf8dxqdah1hsqwmckasqlh9i6zzm9qz9ncc4i7";
      "1.6.2" = "0jjz4n1bdd0r86pf8dxqdah1hsqwmckasqlh9i6zzm9qz9ncc4i7";
    }.${version} or (builtins.trace "Decred fullnode: using dummy vendor SHA256" "0000000000000000000000000000000000000000000000000000");

    src = builtins.fetchGit {
      url = "https://github.com/decred/dcrd.git";
      ref = "refs/tags/release-v${version}";
    };

    subPackages = ["."];
    runVend = true;
    doCheck = false;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/dcrd" ];
      User = "1000:1000";
    };
  };
}
