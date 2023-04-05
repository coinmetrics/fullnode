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
  version = "2.15.3";

  src = fetchFromGitHub {
    owner = "algorand";
    repo = "indexer";
    rev = version;
    hash = "sha256-Q2SNN03LohUpiMWme6YRT0WTjCwX2z31wPdXzoa3o8A=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-8HZ79NNWPxcU44s4KjBze4MMSPaofAJW2AakBr5jiwc=";

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
    if [[ "$name" == "${pname}-${version}-go-modules" ]]; then
      pushd third_party/go-algorand
      export OSARCHTYPE=$(./scripts/osarchtype.sh)
      make crypto/libs/$OSARCHTYPE/lib/libsodium.a
      popd
    fi

    if [[ "$name" == "${pname}-${version}" ]]; then
      pushd idb/postgres/internal/schema
      go generate
      popd
    fi
  '';

  postBuild = ''
    if [[ "$name" == "${pname}-${version}-go-modules" ]]; then
      mkdir -p vendor/github.com/algorand/go-algorand/crypto/libs/$OSARCHTYPE
      cp -r third_party/go-algorand/crypto/libs/$OSARCHTYPE/* vendor/github.com/algorand/go-algorand/crypto/libs/$OSARCHTYPE
    fi
  '';
}
