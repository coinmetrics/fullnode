{ autoreconfHook
, boost
, fetchFromGitHub
, libevent
, openssl
, pkg-config
, stdenv
}:
stdenv.mkDerivation rec {
  pname = "elements";
  version = "23.2.1";

  src = fetchFromGitHub {
    owner = "ElementsProject";
    repo = "elements";
    rev = "elements-${version}";
    sha256 = "sha256-qHtSgfZGZ4Beu5fsJAOZm8ejj7wfHBbOS6WAjOrCuw4=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = [ boost libevent openssl ];

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--disable-shared"
    "--disable-wallet"
    "--disable-bench"
    "--disable-tests"
  ];

  doCheck = false;

  enableParallelBuilding = true;
}
