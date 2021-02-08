{ nixpkgs, version }:
rec {
  package = with nixpkgs; rustPackages_1_45.rustPlatform.buildRustPackage {
    pname = "openethereum";
    inherit version;
    cargoSha256 = {
      "2.5.13" = "04g5jk48y4fi53ychq5l4xg99l65vfw41zvnhmrrbabzjh16cngk";
      "3.1.0" = "0lbsyxjjhgn3np17w2n5f3pwaw8fv5jli3hzxnb86s3w9ssrvk30";
      "3.1.1" = "01jf7zl97addkazdh1wmf1hvspzjc6x5ac7yfxvw1x9z60jljkm5";
    }.${version} or (builtins.trace "OpenEthereum fullnode: using dummy cargo SHA256" "0000000000000000000000000000000000000000000000000000");
    src = builtins.fetchGit {
      url = "https://github.com/openethereum/openethereum.git";
      ref = "refs/tags/v${version}";
    };

    cargoPatches = {
      "2.5.13" = [./2.5.13.patch];
      "3.0.1" = [./3.0.1.patch];
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
