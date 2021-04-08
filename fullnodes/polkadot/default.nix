{ nixpkgs, version }:
rec {
  package = with nixpkgs; rustPlatform.buildRustPackage {
    pname = "polkadot";
    inherit version;
    cargoSha256 = {
      "0.8.26-1" = "1581xvarmcq5rgwpincc031q9wxaq4by4xwdvm45sh6n3xjf714v";
      "0.8.28-1" = "12l8d2bp4vrhvwhmc0l317krwphxmzdzfpq9hpvairpif3hkhgv7";
      "0.8.29" = "1mmi1aaxsv55flvl5dggnvxxxsn18nvh9vmic9kqgxkvnwi92ng1";
      "0.8.30" = "1xcadx5vnnaygqksyh58qc2jjgpg7hfgi3149l64aaf72316vi84";
    }.${version} or (builtins.trace "Polkadot fullnode: using dummy cargo SHA256" "0000000000000000000000000000000000000000000000000000");
    src = builtins.fetchGit {
      url = "https://github.com/paritytech/polkadot.git";
      ref = "refs/tags/v${version}";
    };

    nativeBuildInputs = [ clang ];
    buildInputs = [ pkgconfig openssl ];
    LIBCLANG_PATH = "${llvmPackages.libclang}/lib";
    PROTOC = "${protobuf}/bin/protoc";

    # building WASM binary is complicated
    # see https://github.com/NixOS/nixpkgs/pull/98785
    # and https://gitlab.w3f.tech/florian/w3fpkgs/-/blob/master/pkgs/parity-polkadot/default.nix
    SKIP_WASM_BUILD = 1;

    runVend = true;
    doCheck = false;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/polkadot" ];
      User = "1000:1000";
    };
  };
}
