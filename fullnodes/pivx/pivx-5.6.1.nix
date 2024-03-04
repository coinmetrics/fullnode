{ autoreconfHook, boost, db48, fetchFromGitHub, gmp, libevent, libsodium
, openssl, pkg-config, rustPlatform, stdenv }:
let
  version = "5.6.1";

  src = fetchFromGitHub {
    owner = "PIVX-Project";
    repo = "PIVX";
    rev = "v${version}";
    hash = "sha256-NYNeH77Mjh5nnkPeLw0ucnYD0Zzjd5O107gsGBjhz8U=";
  };

  librustzcash = rustPlatform.buildRustPackage {
    pname = "pivx-librustzcash";
    inherit version src;

    cargoLock = {
      lockFile = ./5.6.1-Cargo.lock;
      outputHashes = {
         "equihash-0.2.0" = "sha256-ACPdTZAhhfs/QGhszU+PIdBQS+cImR2O82eepJFFVNM=";
       };
    };

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
      #./patches/add-missing-headers.patch

      # https://github.com/relic-toolkit/relic/issues/202
      # https://github.com/BLAKE2/BLAKE2/tree/54f4faa4c16ea34bcd59d16e8da46a64b259fc07/ref
      #./patches/fix-blake2-alignment-error.patch
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
