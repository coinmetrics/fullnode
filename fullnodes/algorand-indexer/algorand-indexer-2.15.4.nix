{ autoconf
, automake
, boost
, buildGo118Module
, fetchFromGitHub
, git
, libtool
, which
}:
buildGo118Module rec {
  pname = "algorand-indexer";
  version = "2.15.4";

  outputs = [ "out" "genesis" ];

  src = fetchFromGitHub {
    owner = "algorand";
    repo = "indexer";
    rev = version;
    hash = "sha256-rDxNSF2Oh+ZDXL+ng9VRuTP09hZlIONPhGZhnwkZoTo=";
    fetchSubmodules = true;
    leaveDotGit = true;
  };

  vendorHash = "sha256-8PvCsIl5+wysO+BtYLQwiCAa3s0jU6tb7b6NHcjTKaI=";
  #vendorHash = "sha256-0000000000000000000000000000000000000000000=";

  nativeBuildInputs = [
    autoconf
    automake
    git
    libtool
    which
  ];

  buildInputs = [
    boost
  ];

  subPackages = [
    "cmd/algorand-indexer"
  ];

  preBuild = ''
    if [[ "$name" == "${pname}-${version}" ]]; then
      pushd idb/postgres/internal/schema
      go generate
      popd
    fi
  '';

  modPostBuild = ''
    pushd third_party/go-algorand
    export OSARCHTYPE=$(./scripts/osarchtype.sh)
    make crypto/libs/$OSARCHTYPE/lib/libsodium.a
    popd

    mkdir -p vendor/github.com/algorand/go-algorand/crypto/libs/$OSARCHTYPE
    cp -r third_party/go-algorand/crypto/libs/$OSARCHTYPE/* vendor/github.com/algorand/go-algorand/crypto/libs/$OSARCHTYPE
  '';

  postInstall = ''
    mkdir -p $genesis
    cp -r third_party/go-algorand/installer/genesis/* $genesis
  '';
}
