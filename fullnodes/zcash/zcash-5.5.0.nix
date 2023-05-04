{ autoreconfHook
, bintools
, boost
, cargo
, coreutils
, curl
, cxx-rs
, db
, fetchFromGitHub
, git
, hexdump
, lib
, libevent
, libsodium
, makeWrapper
, rust
, rustPlatform
, pkg-config
, Security
, stdenv
, testers
, tl-expected
, utf8cpp
, util-linux
, zcash
, zeromq
}:

rustPlatform.buildRustPackage.override { inherit stdenv; } rec {
  pname = "zcash";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "zcash";
    repo  = "zcash";
    rev = "v${version}";
    hash = "sha256-USot1fnE6kzyI7DG/pNeiXYAQ5WJPBD9bfv9T4pG/Fw=";
  };

  prePatch = lib.optionalString stdenv.isAarch64 ''
    substituteInPlace .cargo/config.offline \
      --replace "[target.aarch64-unknown-linux-gnu]" "" \
      --replace "linker = \"aarch64-linux-gnu-gcc\"" ""
  '';

  cargoHash = "sha256-XGRBBLznlkjSIG2Lb7rIyUeHyNuMbi18sgYm6AAxHjQ=";

  nativeBuildInputs = [
    autoreconfHook
    bintools
    cargo
    cxx-rs
    git
    hexdump
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    boost
    db
    libevent
    libsodium
    tl-expected
    utf8cpp
    zeromq
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  # Use the stdenv default phases (./configure; make) instead of the
  # ones from buildRustPackage.
  configurePhase = "configurePhase";
  buildPhase = "buildPhase";
  checkPhase = "checkPhase";
  installPhase = "installPhase";

  postPatch = ''
    # Have to do this here instead of in preConfigure because
    # cargoDepsCopy gets unset after postPatch.
    configureFlagsArray+=("RUST_VENDORED_SOURCES=$cargoDepsCopy")
  '';

  preConfigure = ''
    export CFLAGS="-pipe -O3"
    export CXXFLAGS="-pipe -O3 -I${lib.getDev utf8cpp}/include/utf8cpp -I${lib.getDev cxx-rs}/include"
    export LDFLAGS="-fuse-ld=lld"
  '';

  NIX_HARDENING_ENABLE = "";
  dontDisableStatic = true;

  configureFlags = [
    "--disable-tests"
    "--disable-bench"
    "--disable-mining"
    "--with-boost-libdir=${lib.getLib boost}/lib"
    "RUST_TARGET=${rust.toRustTargetSpec stdenv.hostPlatform}"
  ];

  enableParallelBuilding = true;

  # Requires hundreds of megabytes of zkSNARK parameters.
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = zcash;
    command = "zcashd --version";
    version = "v${zcash.version}";
  };

  postInstall = ''
    wrapProgram $out/bin/zcash-fetch-params \
        --set PATH ${lib.makeBinPath [ coreutils curl util-linux ]}
  '';

  meta = with lib; {
    description = "Peer-to-peer, anonymous electronic cash system";
    homepage = "https://z.cash/";
    maintainers = with maintainers; [ rht tkerber centromere ];
    license = licenses.mit;

    # https://github.com/zcash/zcash/issues/4405
    broken = stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isDarwin;
  };
}
