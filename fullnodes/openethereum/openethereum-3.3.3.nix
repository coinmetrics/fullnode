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
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "openethereum";
    repo = "openethereum";
    rev = "v${version}";
    #sha256 = "sha256-GPlUbfFqsmi4J3f3bE/FW9Go/P6C8vfFmQKWeWkGaD0=";
  };

  cargoPatches = [
    ./patches/000-Cargo.lock-3.3.2.patch
    ./patches/001-logos-3.3.2.patch
  ];

  #cargoHash = "sha256-m/SBHv3BNYKkSXxHnCdVng3blbHrTc/HxX/nEIa1DnM=";
  cargoHash = lib.fakeHash;  # only for getting the right value

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
