{ autoconf
, automake
, boost
, buildGo118Module
, curl
, expect
, fetchFromGitHub
, git
, lib
, libtool
, sqlite
, stdenv
, which
}:
buildGo118Module rec {
  pname = "algorand";
  version = "3.15.0";

  outputs = [ "out" "genesis" ];

  src = fetchFromGitHub {
    owner = "algorand";
    repo = "go-algorand";
    rev = "v${version}-stable";
    hash = "sha256-8JV2205kdM640umcIV3cYIk5lFciYpvxxOoxkgzRz/8=";
    leaveDotGit = true;
  };

  vendorHash = "sha256-9T1k2DbMAML0MOP4jgzHcESnsrv/KIFh+2eLVHxDOrI=";

  postPatch = ''
    patchShebangs --build ./scripts
  '';

  nativeBuildInputs = [
    autoconf
    automake
    git
    libtool
    which
  ];

  buildInputs = [
    boost
    sqlite
  ];

  excludedPackages = [
    "partitiontest_linter"
    "data/transactions/verify"
    "test/e2e-go/cli/goal"
  ];

  tags = [
    "libsqlite3"
  ] ++ lib.optionals stdenv.isLinux [
    "linux"
  ];

  preBuild = ''
    if [[ "$name" == "${pname}-${version}" ]]; then
      OSARCHTYPE=$(./scripts/osarchtype.sh)
      make crypto/libs/$OSARCHTYPE/lib/libsodium.a

      export BRANCH=rel/stable
      export BUILDNUMBER=$(./scripts/compute_build_number.sh)
      export COMMITHASH=$(./scripts/compute_build_commit.sh)
      export BUILDBRANCH=$(./scripts/compute_branch.sh)
      export DEFAULT_DEADLOCK=$(./scripts/compute_branch_deadlock_default.sh $BUILDBRANCH)
      export CHANNEL=$(./scripts/compute_branch_channel.sh $BUILDBRANCH)

      export ldflags="-X github.com/algorand/go-algorand/config.BuildNumber=$BUILDNUMBER \
                     -X github.com/algorand/go-algorand/config.CommitHash=$COMMITHASH \
                     -X github.com/algorand/go-algorand/config.Branch=$BUILDBRANCH \
                     -X github.com/algorand/go-algorand/config.DefaultDeadlock=$DEFAULT_DEADLOCK \
                     -X github.com/algorand/go-algorand/config.Channel=$CHANNEL"
    fi
  '';

  preCheck = ''
    export ALGOTEST=1
    export PATH=$GOPATH/bin:$PATH
  '';

  checkFlags = [
    "-timeout"
    "1h"
  ];

  nativeCheckInputs = [
    curl
    expect
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $GOPATH/bin/algod $out/bin

    mkdir -p $genesis
    cp -r installer/genesis/* $genesis

    runHook postInstall
  '';
}
