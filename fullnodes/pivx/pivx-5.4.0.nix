{ autoreconfHook, boost17x, db48, fetchFromGitHub, gmp, libevent, libsodium
, openssl, pkg-config, rustPlatform, stdenv }:
let
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "PIVX-Project";
    repo = "PIVX";
    rev = "e05705aea04fab82d3c2026c01aecc84a69ac71d";
    sha256 = "sha256-kVgiLeV4NA90wogDj0eJ+F6L77tw/13YYT1QsU7Ah4Q=";
  };

  librustzcash = rustPlatform.buildRustPackage {
    pname = "pivx-librustzcash";
    inherit version src;

    cargoSha256 = "sha256-OLaM7gOqpVEtSgNmSg8y8hMH5nzOGIiCuMV34HwpA5g=";

    proxyVendor = true;
    doCheck = false;
  };
in
  stdenv.mkDerivation {
    pname = "pivx";
    inherit version src;

    nativeBuildInputs = [ autoreconfHook pkg-config ];

    buildInputs = [ boost17x db48 gmp libevent librustzcash libsodium openssl ];

    patches = [
      ./patches/add-missing-header.patch

      # https://github.com/relic-toolkit/relic/issues/202
      # https://github.com/BLAKE2/BLAKE2/tree/54f4faa4c16ea34bcd59d16e8da46a64b259fc07/ref
      ./patches/fix-blake2-alignment-error.patch
    ];

    preAutoreconf = "sed -ie 's/: cargo-build/:/' src/Makefile.am";

    configureFlags = [
      "--with-boost-libdir=${boost17x.out}/lib"
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
