{ nixpkgs, version }:
rec {
  package = with nixpkgs; buildGoModule {
    pname = "neo-go";
    inherit version;

    vendorSha256 = {
      "0.77.0" = "12rrlsg4llkb5445y68hp60cky8srr91sbmdh2ab1z9yf33ra89k";
      "0.78.0" = "0rdg2qysc39y5x9c2d7qfih7wqw43s0vxgmvjckh86v9qj7d5h79";
      "0.78.1" = "11fvf1lnxbwxvks2vnnl4kkhzgx1aarhfhv9xvbhp206zdz255l5";
      "0.78.2" = "11fvf1lnxbwxvks2vnnl4kkhzgx1aarhfhv9xvbhp206zdz255l5";
      "0.92.0" = "0fzvxlnf7p1vay25h6sjdbraga8nzgyjhz1pk7rxxizs7vz1gx7m";
      "0.78.3" = "11fvf1lnxbwxvks2vnnl4kkhzgx1aarhfhv9xvbhp206zdz255l5";
    }.${version} or (builtins.trace "NEO Go fullnode: using dummy vendor SHA256" "0000000000000000000000000000000000000000000000000000");

    src = builtins.fetchGit {
      url = "https://github.com/nspcc-dev/neo-go.git";
      ref = "refs/tags/v${version}";
    };

    buildFlagsArray = [ "-ldflags=-X github.com/nspcc-dev/neo-go/pkg/config.Version=${version}" ];

    runVend = true;
    doCheck = false;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/cli" ];
      User = "1000:1000";
    };
  };
}
