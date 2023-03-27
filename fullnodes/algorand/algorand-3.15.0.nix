{ autoconf
, automake
, boost
, buildGo118Module
, expect
, fetchFromGitHub
, git
, libtool
, sqlite
}:
buildGo118Module rec {
  pname = "algorand";
  version = "3.15.0";

  src = fetchFromGitHub {
    owner = "algorand";
    repo = "go-algorand";
    rev = "v${version}-stable";
    hash = "sha256-gx5MvR/+rseZJXvSEGGTg0iMik5DiuE4dOVrlLLi/QE=";
  };

  vendorHash = "sha256-9T1k2DbMAML0MOP4jgzHcESnsrv/KIFh+2eLVHxDOrI=";

  nativeBuildInputs = [
    autoconf
    automake
    expect
    git
    libtool
  ];

  buildInputs = [
    boost
    sqlite
  ];

  preBuild = ''
    make crypto/libs/linux/amd64/lib/libsodium.a
    rm -rf ./cmd/partitiontest_linter
    rm -rf ./test/e2e-go/cli/algod
  '';

  tags = [
    "libsqlite3"
    "linux"
  ];
}
