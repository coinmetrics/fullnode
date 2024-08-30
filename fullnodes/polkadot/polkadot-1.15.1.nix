{ clang
, fetchFromGitHub
, git
, lib
, llvmPackages
, perl
, protobuf
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "polkadot";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "polkadot-sdk";
    rev = "polkadot-v${version}";
    hash = "sha256-WEH0ICe66AbhNufqZz2kWCdV8UVIxjdHUPIJ1A44e6Y=";
  };

  postPatch = ''
    cp ${./Cargo-1.15.1.lock} Cargo.lock
  '';

  cargoLock = {
    lockFile = ./Cargo-1.15.1.lock;
    outputHashes = {
      "simple-mermaid-0.1.0" = "sha256-IekTldxYq+uoXwGvbpkVTXv2xrcZ0TQfyyE2i2zH+6w=";
    };
  };

  nativeBuildInputs = [
    clang
    git
    perl
    protobuf
  ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  # NOTE: We don't build the WASM runtimes since this would require a more
  # complicated rust environment setup and this is only needed for developer
  # environments. The resulting binary is useful for end-users of live networks
  # since those just use the WASM blob from the network chainspec.
  SKIP_WASM_BUILD = 1;

  # We can't run the test suite since we didn't compile the WASM runtimes.
  doCheck = false;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Polkadot Node Implementation";
    homepage = "https://polkadot.network";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ akru andresilva asymmetric FlorianFranzen RaghavSood ];
    platforms = platforms.linux;
  };
}
