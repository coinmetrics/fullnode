{ nixpkgs, version }:
rec {
  package = with nixpkgs; buildGoModule {
    pname = "neo-go";
    inherit version;

    vendorSha256 = {
      "0.77.0" = "12rrlsg4llkb5445y68hp60cky8srr91sbmdh2ab1z9yf33ra89k";
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
