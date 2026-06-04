{ autoreconfHook
, boost
, coreutils
, curl
, cxx-rs
, db
, fetchFromGitHub
, fetchpatch
, git
, hexdump
, lib
, libevent
, libsodium
, llvmPackages
, makeRustPlatform
, makeWrapper
, overrideCC
, pkg-config
, rust-bin
, rustPlatform
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

  rustToolchain = rust-bin.stable."1.96.0".default;

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

  boost' = (boost.override {
    stdenv = clangStdenv;
  }).overrideAttrs (old: {
    patches = old.patches ++ [
      (fetchpatch {
        url = "https://raw.githubusercontent.com/zcash/zcash/v6.12.3/depends/patches/boost/6753-signals2-function-fix.patch";
        stripLen = 0;
        sha256 = "sha256-LSmGZkswjbT1tDEKabGq/0e4UC6iJoo/8dJLOOHGGls=";
      })
    ];
  });

  db' = db.override { stdenv = clangStdenv; };

  # cxx 1.0.189 introduced version-encoded symbol names for non-Cargo builds.
  # nixpkgs ships cxx-rs 1.0.175 which generates cxxbridge1$* symbols; zcash
  # 6.12.5 links against cxx 1.0.194 which exports cxxbridge194$* symbols.
  # Override to match exactly.
  cxx-rs' = rustPlatform.buildRustPackage {
    pname = "cxx-rs";
    version = "1.0.194";
    src = fetchFromGitHub {
      owner = "dtolnay";
      repo = "cxx";
      rev = "1.0.194";
      hash = "sha256-PIeF9VuyJOIs1x02YETKIP0+nCG3RZXLMJdFNlgAFzo=";
    };
    cargoLock.lockFile = ./cxx-rs-1.0.194-Cargo.lock;
    cargoBuildFlags = [ "--workspace" "--exclude=demo" ];
    postPatch = ''
      cp ${./cxx-rs-1.0.194-Cargo.lock} Cargo.lock
    '';
    postInstall = ''
      mkdir -p $dev/include/rust
      install -D -m 0644 ./include/cxx.h $dev/include/rust
    '';
    outputs = [ "out" "dev" ];
  };

  rustPlatform' = makeRustPlatform {
    rustc = rustToolchain;
    cargo = rustToolchain;
  };
in
rustPlatform'.buildRustPackage.override { stdenv = clangStdenv; } rec {
  pname = "zcash";
  version = "6.20.0";

  src = fetchFromGitHub {
    owner = "zcash";
    repo  = "zcash";
    rev = "v${version}";
    hash = "sha256-NX6/yYK1h0jhFj9EjT8MYbj/1xIhcSid9xhtjoxlzCo=";
  };

  cargoLock = {
    lockFile = ./6.20.0-Cargo.lock;
  };

  nativeBuildInputs = [
    autoreconfHook
    cxx-rs'
    git
    hexdump
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    boost'
    db'
    libevent
    libsodium
    tl-expected
    utf8cpp
    zeromq
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

    # ecdsa_signature_parse_der_lax is non-static in zcash's lax_der_parsing.c
    # but only listed as noinst_HEADERS so it never gets compiled into
    # libsecp256k1.a. secp256k1-sys 0.10.1 (new in 6.12.5) needs it as a
    # global symbol when using rust_secp_no_symbol_renaming.
    sed -i 's|libsecp256k1_la_SOURCES = src/secp256k1.c|libsecp256k1_la_SOURCES = src/secp256k1.c contrib/lax_der_parsing.c|' src/secp256k1/Makefile.am

    # lax_der_parsing.h uses <secp256k1.h> (angle brackets) but the include/
    # directory is not in the -I search path when built as a secp256k1 subdir.
    sed -i 's|#include <secp256k1.h>|#include "../include/secp256k1.h"|' src/secp256k1/contrib/lax_der_parsing.h
  '';

  preConfigure = ''
    export CFLAGS="-pipe -O3 -Wno-unknown-warning-option"
    export CXXFLAGS="-pipe -O3 -Wno-unknown-warning-option -I${lib.getDev utf8cpp}/include/utf8cpp -I${lib.getDev cxx-rs'}/include"
    export CARGO_PROFILE_RELEASE_LTO=false
  '';

  hardeningEnable = [ ];
  dontDisableStatic = true;

  configureFlags = [
    "--disable-tests"
    "--disable-bench"
    "--with-boost-libdir=${lib.getLib boost'}/lib"
    "RUST_TARGET=${clangStdenv.hostPlatform.rust.rustcTargetSpec}"
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
    broken = with clangStdenv.hostPlatform; isAarch64 && isDarwin;
  };
}
