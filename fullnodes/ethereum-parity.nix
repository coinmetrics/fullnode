{ nixpkgs, version }:
rec {
  package = with nixpkgs; rustPlatform.buildRustPackage {
    pname = "ethereum-parity";
    inherit version;
    cargoSha256 = {
      "2.5.13" = "0v942qap7pbmwnhra58xjyynws5b3rknv85mri53db7wha6c6ng7";
      "2.6.8" = "1kxvwi63v3rilavm29y8xz1hyg7xpd502p57260zdfx8055xfibx";
      "2.7.2" = "164sv7xs8qgpxf978dqb343w607y6dlbc2bzn1ma45d0pz0k0n7k";
    }.${version};
    src = builtins.fetchGit {
      url = "https://github.com/paritytech/parity-ethereum.git";
      ref = "refs/tags/v${version}";
    };

    nativeBuildInputs = [ cmake llvmPackages.llvm llvmPackages.clang ];

    buildInputs = [ systemd llvmPackages.libclang ];

    LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

    cargoBuildFlags = [ "--features final" ];

    doCheck = false;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/parity" ];
      User = "1000:1000";
    };
  };
}
