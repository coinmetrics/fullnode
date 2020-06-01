{ nixpkgs, version }:
rec {
  package = with nixpkgs; rustPlatform.buildRustPackage {
    pname = "ethereum";
    inherit version;
    cargoSha256 = {
      "2.5.13" = "0kgc67r0i2i7nql8jrmsyjvky1rzcqgr6ayaxxqxkia1wjzajwya";
      "2.6.8" = "0l89fa44rkphjibaiglvgcsk6n9gqhzf3sqs0af78jxw9ya8pchm";
      "2.7.2" = "1mfi8rh6gbdgq7gdxwdpnr53dd5cxavmy8w12b9nvbxc8lpwf832";
      "3.0.0" = "1y5kq1kmzlrax02x40wiyq4g714jl8vbfgyzaya7mybci7qy0cz2";
      "3.0.1" = "1pzrz9hppg0b1bry1r42xi2qsn5crb4pz7alc1r5x8lzk2pif0bk";
    }.${version} or (builtins.trace "Ethereum fullnode: using dummy cargo SHA256" "0000000000000000000000000000000000000000000000000000");
    src = builtins.fetchGit {
      url = "https://github.com/openethereum/openethereum.git";
      ref = "refs/tags/v${version}";
    };

    cargoPatches = {
      "3.0.1" = [./ethereum/3.0.1.patch];
    }.${version} or [];

    nativeBuildInputs = [ cmake llvmPackages.llvm llvmPackages.clang ];

    buildInputs = [ systemd llvmPackages.libclang ];

    LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

    cargoBuildFlags = [ "--features final" ];

    doCheck = false;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/${ if builtins.compareVersions version "3.0.0" < 0 then "parity" else "openethereum" }" ];
      User = "1000:1000";
    };
  };
}
