{ autoreconfHook, boost, fetchFromGitHub, libevent, openssl, pkgconfig, stdenv }:
stdenv.mkDerivation {
  pname = "elements";
  version = "0.21.0.2";

  src = fetchFromGitHub {
    owner = "ElementsProject";
    repo = "elements";
    rev = "386ed09e27fccf48c675c61c614562cf4491c6f8";
    sha256 = "sha256-5b3wylp9Z2U0ueu2gI9jGeWiiJoddjcjQ/6zkFATyvA=";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];

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
