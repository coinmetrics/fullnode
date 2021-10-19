{ lib
, fetchFromGitHub
, rustPlatform
, cmake
, llvmPackages
, openssl
, pkg-config
, stdenv
, systemd
, darwin
}:

rustPlatform.buildRustPackage.override { stdenv = stdenv; } rec {
  pname = "openethereum";
  version = "3.3.0-rc.4";

  src = fetchFromGitHub {
    owner = "openethereum";
    repo = "openethereum";
    rev = "v${version}";
    sha256 = "0z11sb648h72mvbsk9aii7rfq2nzmh7s8lx274hfinbc81nz5wjl";
  };

  cargoPatches = [
    ./patches/000-Cargo.lock.patch
    ./patches/001-logos.patch
  ];

  cargoSha256 = "0000000000000000000000000000000000000000000000000000";

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isLinux [ systemd ]
    ++ lib.optionals stdenv.isDarwin [ darwin.Security ];

  cargoBuildFlags = [ "--features final" ];

  # Fix tests by preventing them from writing to /homeless-shelter.
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # Exclude some tests that don't work in the sandbox
  # - Nat test requires network access
  checkFlags = "--skip configuration::tests::should_resolve_external_nat_hosts";

  meta = with lib; {
    description = "Fast, light, robust Ethereum implementation";
    homepage = "http://parity.io/ethereum";
    license = licenses.gpl3;
    maintainers = with maintainers; [ akru xrelkd ];
    platforms = lib.platforms.unix;
  };
}
