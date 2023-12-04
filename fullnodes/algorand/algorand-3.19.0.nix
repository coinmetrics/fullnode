{ autoconf
, automake
, buildGo120Module
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
buildGo120Module rec {
  pname = "algorand";
  version = "3.19.0";

  outputs = [ "out" "genesis" ];

  src = fetchFromGitHub {
    owner = "algorand";
    repo = "go-algorand";
    rev = "v${version}-stable";
    hash = "sha256-M9tUvZQzCvsN7+1WeDZHTkg0jCtVx7wkJGtU0JaPDK4=";
  };

  vendorHash = "sha256-SdSSrN3mRpmfp77xCtjeYwtVF1kLoty7pzBv5MhgcxI=";

  postPatch = ''
    patchShebangs --build ./scripts
  '';

  proxyVendor = true;

  nativeBuildInputs = [
    autoconf
    automake
    git
    libtool
    which
  ];

  buildInputs = [
    sqlite
  ];

  excludedPackages = [
    "partitiontest_linter"
    "data/transactions/verify"
    "test/e2e-go/cli/goal"
    "tools/block-generator"
    "tools/x-repo-types"
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

  # [AW] Temporary
  doCheck = false;
}
