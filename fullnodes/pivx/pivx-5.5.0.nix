{ autoreconfHook, boost, db48, fetchFromGitHub, gmp, libevent, libsodium
, openssl, pkg-config, rustPlatform, stdenv }:
let
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "PIVX-Project";
    repo = "PIVX";
    rev = "7fc4e325bd3b6d4df7f846c8a11ec8dc0f88c8be";
    hash = "sha256-+C+k72RnWvmoRBZ7eWaBPRxVll0hkg9SvkJj9WimZT4=";
  };

  librustzcash = rustPlatform.buildRustPackage {
    pname = "pivx-librustzcash";
    inherit version src;

    cargoSha256 = "sha256-OAoqwY85+J/zpH0jJnn2qNW+zaQGp6KfWSKy/ep9L6Q=";

    proxyVendor = true;
    doCheck = false;
  };
in
  stdenv.mkDerivation {
    pname = "pivx";
    inherit version src;

    nativeBuildInputs = [ autoreconfHook pkg-config ];

    buildInputs = [ boost db48 gmp libevent librustzcash libsodium openssl ];

    patches = [
      ./patches/add-missing-headers.patch

      # https://github.com/relic-toolkit/relic/issues/202
      # https://github.com/BLAKE2/BLAKE2/tree/54f4faa4c16ea34bcd59d16e8da46a64b259fc07/ref
      ./patches/fix-blake2-alignment-error.patch
    ];

    preAutoreconf = "sed -ie 's/: cargo-build/:/' src/Makefile.am";

    configureFlags = [
      "--with-boost-libdir=${boost}/lib"
      "--disable-shared"
      "--disable-bench"
      "--disable-tests"
      # "--disable-wallet" Build breaks with this >:(
      "--disable-online-rust"
    ];

    makeFlags = "LIBRUSTZCASH=${librustzcash}/lib/librustzcash.a";

    doCheck = false;

    enableParallelBuilding = true;
  }
