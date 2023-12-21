{ clang
, fetchFromGitHub
, git
, lib
, llvmPackages
, protobuf
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "polkadot";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "polkadot-sdk";
    rev = "polkadot-v${version}";
    hash = "sha256-xyl2iVS9R1QfCiFX918MNsaXDigVOnPaieRuXZ953fo=";
  };

  patches = [
    ./patches/fix-cargo-config.patch
  ];

  postPatch = ''
    cp ${./Cargo-1.5.0.lock} Cargo.lock
  '';

  cargoLock = {
    lockFile = ./Cargo-1.5.0.lock;
    outputHashes = {
      "ark-secret-scalar-0.0.2" = "sha256-ytwKeUkiXIcwJLo9wpWSIjL4LBZJDbeED5Yqxso9l74=";
      "common-0.1.0" = "sha256-9vTJNKsL6gK8MM8dUKrShEvL9Ac9YQg1q8iVE9+deak=";
      "fflonk-0.1.0" = "sha256-PC7eJEOo/RN9Gk27CcTIyGMA9XZeFAJkO2FK02JVzN0=";
      "simple-mermaid-0.1.0" = "sha256-IekTldxYq+uoXwGvbpkVTXv2xrcZ0TQfyyE2i2zH+6w=";
      "sp-ark-bls12-381-0.4.2" = "sha256-nNr0amKhSvvI9BlsoP+8v6Xppx/s7zkf0l9Lm3DW8w8=";
      "sp-crypto-ec-utils-0.4.1" = "sha256-/Sw1ZM/JcJBokFE4y2mv/P43ciTL5DEm0PDG0jZvMkI=";
    };
  };

  nativeBuildInputs = [
    clang
    git
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
