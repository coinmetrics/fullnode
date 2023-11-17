{ autoconf
, automake
, boost
, buildGo120Module
, fetchFromGitHub
, git
, libtool
, stdenv
, which
}:
let
  # NOTE: Please bump all of these values when upgrading to a new version.
  version = "3.3.0";
  gitCommit = "76f36eac45e2165385225fa5cdfb530849bda6cc";
  gitNixHash = "sha256-+RBaUKYk8q89hpjxRLxVIZAiS5dxqpcDN529gg8rZr4=";
  gitDescription = "dGFnOiAzLjMuMA=="; # TODO: Automate this: echo -n "tag: 3.3.0" | base64

  algorandIndexerLibs = stdenv.mkDerivation {
    inherit version;

    pname = "algorand-indexer-libs";

    # NOTE: They use 'rel/nightly', so it's up to us to pin the rev for reproducibility.
    src = fetchFromGitHub {
      owner = "algorand";
      repo = "go-algorand";
      rev = "6f08413cf0c9c2e9b8469643dfd3ff1af9580135";
      hash = "sha256-PInPmHPQrhAbs2Qhbl/hcFeOFmHfpsMbki6Y1O4++24=";
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
in buildGo120Module rec {
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
