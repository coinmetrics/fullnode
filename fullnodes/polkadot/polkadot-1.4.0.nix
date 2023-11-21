{ clang
, fetchFromGitHub
, lib
, llvmPackages
, protobuf
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "polkadot";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "polkadot-sdk";
    rev = "v${version}";
    hash = "sha256-UwkCT+p/mof6UVfmipj/RAs0y/7TkOb5UIBGdhPrbrQ=";
  };

  cargoLock = {
    lockFile = ./Cargo-1.4.0.lock;
    outputHashes = {
      "ark-secret-scalar-0.0.2" = "sha256-rnU9+rf0POv4GuxKUp9Wv4/eNXi5gfGq+XhJLxpmSzU=";
      "common-0.1.0" = "sha256-ru++KG2ZZqa/wDGnKF/VfWnazHRSpOAD0WYb7rHlpCU=";
      "fflonk-0.1.0" = "sha256-MNvlePHQdY8DiOq6w7Hc1pgn7G58GDTeghCKHJdUy7E=";
      "simple-mermaid-0.1.0" = "sha256-IekTldxYq+uoXwGvbpkVTXv2xrcZ0TQfyyE2i2zH+6w=";
      "sp-ark-bls12-381-0.4.2" = "sha256-nNr0amKhSvvI9BlsoP+8v6Xppx/s7zkf0l9Lm3DW8w8=";
      "sp-crypto-ec-utils-0.4.1" = "sha256-cv2mr5K6mAKiACVzS7mPOIpoyt8iUfGZXsqVuiGXbL0=";
    };
  };

  nativeBuildInputs = [ clang protobuf ];

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
