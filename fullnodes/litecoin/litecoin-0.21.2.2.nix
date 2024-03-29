{ autoreconfHook
, boost177
, db48
, fetchFromGitHub
, fetchpatch
, fmt
, libevent
, openssl
, pkg-config
, stdenv
, zeromq }:
stdenv.mkDerivation rec {
  pname = "litecoin";
  version = "0.21.2.2";

  src = fetchFromGitHub {
    owner = "litecoin-project";
    repo = "litecoin";
    rev = "v${version}";
    hash = "sha256-TuDc47TZOEQA5Lr4DQkEhnO/Szp9h71xPjaBL3jFWuM=";
  };

  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/litecoin-project/litecoin/pull/929.patch";
      hash = "sha256-1y4Iz2plMw5HMAjl9x50QQpYrYaUd2WKrrAcUnQmlBY=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ boost177 db48 fmt libevent openssl zeromq ];

  configureFlags = [
    "--with-boost-libdir=${boost177.out}/lib"
    "--disable-shared"
    "--disable-wallet"
    "--disable-bench"
    "--disable-tests"
  ];

  doCheck = false;

  enableParallelBuilding = true;
}
