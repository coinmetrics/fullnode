{ autoreconfHook, boost179, cargo, coreutils, curl, cxx-rs, db62, fetchFromGitHub
, hexdump, lib, libevent, libsodium, makeWrapper, rust, rustPlatform, pkg-config
, stdenv, testers, utf8cpp, util-linux, zcash, zeromq
}:

rustPlatform.buildRustPackage.override { inherit stdenv; } rec {
  pname = "zcash";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "zcash";
    repo  = "zcash";
    rev = "d6d2093beb66a052059d3771f6195c0bafad84ff";
    sha256 = "sha256-ItjPqyWU5h/XFmFkw4B2+RQURF3LmJXKlwYFbxRnTik=";
  };

  prePatch = lib.optionalString stdenv.isAarch64 ''
    substituteInPlace .cargo/config.offline \
      --replace "[target.aarch64-unknown-linux-gnu]" "" \
      --replace "linker = \"aarch64-linux-gnu-gcc\"" ""
  '';

  patches = [
    ./patches/5.2.0-fix-build-errors.patch
  ];

  cargoSha256 = "sha256-TPvAIgQO9IumFK5wCOIhfpfCQaPcLgcX1iAqdsYeGsI=";

  nativeBuildInputs = [ autoreconfHook cargo cxx-rs hexdump makeWrapper pkg-config ];

  buildInputs = [ boost179 db62 libevent libsodium utf8cpp zeromq ];

  # Use the stdenv default phases (./configure; make) instead of the
  # ones from buildRustPackage.
  configurePhase = "configurePhase";
  buildPhase = "buildPhase";
  checkPhase = "checkPhase";
  installPhase = "installPhase";

  postPatch = ''
    # Have to do this here instead of in preConfigure because
    # cargoDepsCopy gets unset after postPatch.
    configureFlagsArray+=("RUST_VENDORED_SOURCES=$NIX_BUILD_TOP/$cargoDepsCopy")
  '';

  CXXFLAGS = [
    "-I${lib.getDev utf8cpp}/include/utf8cpp"
    "-I${lib.getDev cxx-rs}/include"
  ];

  configureFlags = [
    "--disable-tests"
    "--disable-bench"
    "--disable-mining"
    "--with-boost-libdir=${lib.getLib boost179}/lib"
    "RUST_TARGET=${rust.toRustTargetSpec stdenv.hostPlatform}"
  ];

  # Workaround for problem identified in:
  # https://github.com/NixOS/nixpkgs/pull/174473
  enableParallelBuilding = false;
  preBuild = ''
    makeFlagsArray+=("-j$NIX_BUILD_CORES")
  '';

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
