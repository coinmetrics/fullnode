{ nixpkgs, version }:
rec {
  package = with nixpkgs; rustPlatform.buildRustPackage {
    pname = "openethereum";
    inherit version;
    cargoSha256 = {
      "2.5.13" = "04g5jk48y4fi53ychq5l4xg99l65vfw41zvnhmrrbabzjh16cngk";
      "2.5.14" = "0hb2cxb80nihgg4hyv40r67n32zdzl9w23cssq4w7azhripq8idx";
      "2.6.8" = "0gigrxcc5sapmygxg2xg6ja9h1j3553mmagwx8acrjzrk7z09i6d";
      "2.7.2" = "1i9vz3hjpndyyqm3si8lj3csx9zmfs93sb1i14i9lwj6bzqx1lcg";
      "3.0.0" = "0cpzjw5pdbagfpcsd2r11zzxzvh7mpinh5m0snbgql5cmiv6swks";
      "3.0.1" = "0sbrz27isaxw84mj224bwdsqwgxxyr5ifq19h3fx1254skz7x7wz";
      "3.1.0" = "0lbsyxjjhgn3np17w2n5f3pwaw8fv5jli3hzxnb86s3w9ssrvk30";
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
