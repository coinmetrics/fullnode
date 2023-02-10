{ autoreconfHook, boost, cargo, coreutils, curl, cxx-rs, db, fetchFromGitHub
, fetchurl, git, hexdump, lib, libevent, libsodium, makeWrapper, rust, rustPlatform
, pkg-config, runCommand, stdenv, testers, utf8cpp, util-linux, zcash, zeromq
}:

rustPlatform.buildRustPackage.override { inherit stdenv; } rec {
  pname = "zcash";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "zcash";
    repo  = "zcash";
    rev = "v${version}";
    hash = "sha256-c/jaZ7KlP8zIbcXSmicX4fCiVC/td5GWJa3bMG4RCII=";
  };

  # See: https://github.com/TartanLlama/expected/pull/117
  tl-expected = runCommand "tl-expected" {
    src = fetchurl {
      url = "https://raw.githubusercontent.com/daira/expected/remove-undefined-behaviour/include/tl/expected.hpp";
      hash = "sha256-PWMOn18PHvlbC6D2GptIv4TwV5Ay03IAME2gw8OCrEM=";
    };
  } ''
    mkdir -p $out/include/tl
    cp -a $src $out/include/tl/expected.hpp
  '';

  prePatch = lib.optionalString stdenv.isAarch64 ''
    substituteInPlace .cargo/config.offline \
      --replace "[target.aarch64-unknown-linux-gnu]" "" \
      --replace "linker = \"aarch64-linux-gnu-gcc\"" ""
  '';

  cargoHash = "sha256-OAqbwid0FBOFcFO9w6uE0rgtaUAq7Zz4i2ojhxfJQ08=";

  nativeBuildInputs = [ autoreconfHook cargo cxx-rs git hexdump makeWrapper pkg-config ];

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
    "-I${tl-expected}/include"
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
