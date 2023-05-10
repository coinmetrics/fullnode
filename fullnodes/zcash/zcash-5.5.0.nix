{ autoreconfHook
, boost
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
, llvmPackages
, makeWrapper
, overrideCC
, pkg-config
, rust
, rustPlatform
, Security
, stdenv
, testers
, tl-expected
, utf8cpp
, util-linux
, zcash
, zeromq
}:

let
  cpu = stdenv.targetPlatform.parsed.cpu.name;

  clangStdenv = if stdenv.isDarwin
    then llvmPackages.libcxxStdenv
    else overrideCC stdenv (llvmPackages.libcxxClang.override (old: {
      bintools = llvmPackages.bintools;

      nixSupport.cc-cflags = (old.nixSupport.cc-cflags or []) ++ [
        "-rtlib=compiler-rt"
        "-Wno-unused-command-line-argument"
      ];

      nixSupport.cc-ldflags = (old.nixSupport.cc-ldflags or []) ++ [
        "${llvmPackages.compiler-rt}/lib/linux/libclang_rt.builtins-${cpu}.a"
      ];

      nixSupport.libcxx-cxxflags = (old.nixSupport.libcxx-cxxflags or []) ++ [
        "-unwindlib=libunwind"
      ];

      # https://github.com/NixOS/nixpkgs/issues/201591
      nixSupport.libcxx-ldflags = (old.nixSupport.libcxx-ldflags or []) ++ [
        "-L${llvmPackages.libunwind}/lib"
        "-lunwind"
      ];
    }));

  boostWithClang = boost.override { stdenv = clangStdenv; };

  dbWithClang = db.override { stdenv = clangStdenv; };
in
rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } rec {
  pname = "zcash";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "zcash";
    repo  = "zcash";
    rev = "v${version}";
    hash = "sha256-USot1fnE6kzyI7DG/pNeiXYAQ5WJPBD9bfv9T4pG/Fw=";
  };

  cargoLock = {
    lockFile = ./. + "/${version}-Cargo.lock";
  };

  prePatch = lib.optionalString clangStdenv.isAarch64 ''
    substituteInPlace .cargo/config.offline \
      --replace "[target.aarch64-unknown-linux-gnu]" "" \
      --replace "linker = \"aarch64-linux-gnu-gcc\"" ""
  '';

  nativeBuildInputs = [
    autoreconfHook
    cxx-rs
    git
    hexdump
    makeWrapper
    pkg-config
    rustPlatform.rust.cargo
  ];

  buildInputs = [
    boostWithClang
    dbWithClang
    libevent
    libsodium
    tl-expected
    utf8cpp
    zeromq
  ] ++ lib.optionals clangStdenv.isDarwin [
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
  '';

  NIX_HARDENING_ENABLE = "";
  dontDisableStatic = true;

  configureFlags = [
    "--disable-tests"
    "--disable-bench"
    "--disable-mining"
    "--with-boost-libdir=${lib.getLib boostWithClang}/lib"
    "RUST_TARGET=${rust.toRustTargetSpec clangStdenv.hostPlatform}"
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
    broken = clangStdenv.hostPlatform.isAarch64 && clangStdenv.hostPlatform.isDarwin;
  };
}
