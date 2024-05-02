{ autoconf
, automake
, boost
, buildGo121Module
, fetchFromGitHub
, git
, libtool
, stdenv
, which
}:
let
  # NOTE: Please bump all of these values when upgrading to a new version.
  version = "3.4.0";
  gitCommit = "76f36eac45e2165385225fa5cdfb530849bda6cc";
  gitNixHash = "sha256-+RBaUKYk8q89hpjxRLxVIZAiS5dxqpcDN529gg8rZr4=";
  gitDescription = "dGFnOiAzLjMuMA=="; # TODO: Automate this: echo -n "tag: 3.4.0" | base64

  algorandIndexerLibs = stdenv.mkDerivation {
    inherit version;

    pname = "algorand-indexer-libs";

    # NOTE: They use 'rel/nightly', so it's up to us to pin the rev for reproducibility.
    src = fetchFromGitHub {
      owner = "algorand";
      repo = "go-algorand";
      rev = "v3.23.1-stable";
      hash = "sha256-p3cFq2EtTdxS+ZM9XQOny7Xm/g3TPHQTFA5dBW526nU=";
    };

    nativeBuildInputs = [
      autoconf
      automake
      git
      libtool
    ];

    buildPhase = ''
      cd ./crypto/libsodium-fork
      ./autogen.sh --prefix "$out"
      ./configure --disable-shared --prefix="$out"
		  make
    '';

    enableParallelBuilding = true;

    installPhase = ''
      mkdir -p $out
		  make install
    '';
  };
in buildGo121Module rec {
  inherit version;

  pname = "algorand-indexer";

  src = fetchFromGitHub {
    owner = "algorand";
    repo = "indexer";
    rev = gitCommit;
    hash = gitNixHash;
    fetchSubmodules = true;
  };

  vendorHash = "sha256-yrtwQcRzbW6fjvtSFh6aElJA9fJ7W5GVUw8OBXmxb5Y=";

  buildInputs = [
    boost
  ];

  CGO_CPPFLAGS = [
    "-I${algorandIndexerLibs}/include"
  ];

  CGO_LDFLAGS = [
    "${algorandIndexerLibs}/lib/libsodium.a"
  ];

  ldflags = [
    "-s" "-w"
    "-X github.com/algorand/indexer/version.Hash=${src.rev}"
    "-X github.com/algorand/indexer/version.CompileTime=1970-01-01T00:00:00+0000"
    "-X github.com/algorand/indexer/version.Dirty="
    "-X github.com/algorand/indexer/version.ReleaseVersion=${version}"
    "-X github.com/algorand/indexer/version.GitDecorateBase64=${gitDescription}"
  ];

  enableParallelBuilding = true;

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
}
