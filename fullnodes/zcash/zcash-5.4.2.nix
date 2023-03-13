{ autoreconfHook, boost, cargo, coreutils, curl, cxx-rs, db, fetchFromGitHub
, fetchurl, git, hexdump, lib, libevent, libsodium, makeWrapper, rust
, rustPlatform, pkg-config, runCommand, stdenv, testers, tl-expected, utf8cpp
, util-linux, zcash, zeromq
}:

rustPlatform.buildRustPackage.override { inherit stdenv; } rec {
  pname = "zcash";
  version = "5.4.2";

  src = fetchFromGitHub {
    owner = "zcash";
    repo  = "zcash";
    rev = "v${version}";
    hash = "sha256-XGq/cYUo43FcpmRDO2YiNLCuEQLsTFLBFC4M1wM29l8=";
  };

  prePatch = lib.optionalString stdenv.isAarch64 ''
    substituteInPlace .cargo/config.offline \
      --replace "[target.aarch64-unknown-linux-gnu]" "" \
      --replace "linker = \"aarch64-linux-gnu-gcc\"" ""
  '';

  cargoHash = "sha256-Mz8mr/RDcOfwJvXhY19rZmWHP8mUeEf9GYD+3JAPNOw=";
  #cargoHash = "sha256-0000000000000000000000000000000000000000000=";

  nativeBuildInputs = [
    autoreconfHook cargo cxx-rs git hexdump makeWrapper
    pkg-config tl-expected
  ];

  buildInputs = [ boost db libevent libsodium utf8cpp zeromq ];

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

  CXXFLAGS = [
    "-I${lib.getDev utf8cpp}/include/utf8cpp"
    "-I${lib.getDev cxx-rs}/include"
    "-I${lib.getDev tl-expected}/include"
  ];

  configureFlags = [
    "--disable-tests"
    "--disable-bench"
    "--disable-mining"
    "--with-boost-libdir=${boost}/lib"
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
  };
}
