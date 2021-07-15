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
  version = "3.2.5";

  src = fetchFromGitHub {
    owner = "openethereum";
    repo = "openethereum";
    rev = "v${version}";
    sha256 = "1g48fkznvr9fs3j9zy2d9pcwnahmyghxg2b9bsn2mxpyczmfqrki";
  };

  cargoPatches = [
    ./patches/000-Cargo.lock.patch
    ./patches/001-logos.patch
  ];

  cargoSha256 = "1xm5m6dx6mmrp6n4xilqyibsjl0rrf5wj3vj2znxbjihr8m39234";

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
