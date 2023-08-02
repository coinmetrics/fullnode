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
  version = "2.15.4";
  gitCommit = "90a78e33d9f53c624261deaab3d78edc2fd4c4e9";
  gitNixHash = "sha256-jOljMUDKxI9/yrHVUciztOSAq+2kPuGrX1MSu7ij3Tc=";
  gitDescription = "dGFnOiAyLjE1LjQ="; # TODO: Automate this: echo -n "tag: 2.15.4" | base64

  algorandIndexerLibs = stdenv.mkDerivation {
    inherit version;

    pname = "algorand-indexer-libs";

    # NOTE: They use 'rel/nightly', so it's up to us to pin the rev for reproducibility.
    src = fetchFromGitHub {
      owner = "algorand";
      repo = "go-algorand";
      rev = "8f282cf326f05f25b091f5c095fdd500b467a55b";
      hash = "sha256-L0lFHBHSvtl8UG8QEFcxP6UWNjN3I/NKRso4rRAenDU=";
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

  outputs = [ "out" "genesis" ];

  vendorHash = "sha256-FziH6sMNOAdTd0OuW2NP4nA2G8Gd4tvSB6hmy8u0NDo=";

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

  modPostBuild = ''
    find ./vendor/github.com/algorand/go-algorand/crypto -name '*.go' \
      -exec sed -s -i '/-I''${SRCDIR}\/libs\/.*\/.*\/include/d' {} \; \
      -exec sed -s -i '/''${SRCDIR}\/libs\/.*\/.*\/lib\/libsodium\.a/d' {} \;
  '';

  preBuild = ''
    if [[ "$name" == "${pname}-${version}" ]]; then
      pushd idb/postgres/internal/schema
      go generate
      popd
    fi
  '';

  postInstall = ''
    mkdir -p $genesis
    cp -r third_party/go-algorand/installer/genesis/* $genesis
  '';
}
