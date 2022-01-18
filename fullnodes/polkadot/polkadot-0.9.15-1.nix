{ clang
, fetchFromGitHub
, lib
, llvmPackages
, protobuf
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "polkadot";
  version = "0.9.15-1";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "polkadot";
    rev = "v${version}";
    hash = "sha256-Jf6F1U6iJalE8K/hnrTQvkJ6hTIokrtQxx40UY3EbGk=";
  };

  #cargoHash = lib.fakeHash;  # only for getting the right value
  cargoHash = "sha256-czT3c+3cBa3aI/+NwcAXQ1X8sybI+QRjnBr3G4QSgOg=";

  nativeBuildInputs = [ clang ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  PROTOC = "${protobuf}/bin/protoc";

  # NOTE: We don't build the WASM runtimes since this would require a more
  # complicated rust environment setup and this is only needed for developer
  # environments. The resulting binary is useful for end-users of live networks
  # since those just use the WASM blob from the network chainspec.
  SKIP_WASM_BUILD = 1;

  # We can't run the test suite since we didn't compile the WASM runtimes.
  doCheck = false;

  meta = with lib; {
    description = "Polkadot Node Implementation";
    homepage = "https://polkadot.network";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ akru andresilva asymmetric FlorianFranzen RaghavSood ];
    platforms = platforms.linux;
  };
}
