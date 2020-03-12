{ nixpkgs, version }:
rec {
  package = with nixpkgs; rustPlatform.buildRustPackage {
    pname = "grin";
    inherit version;
    cargoSha256 = {
      "3.1.0" = "1kvgiqr8114aq4qxmlkdpvlcn48mdws5j33wk0ik184y0i8zb4gm";
    }.${version};
    src = builtins.fetchGit {
      url = "https://github.com/mimblewimble/grin.git";
      ref = "refs/tags/v${version}";
    };

    nativeBuildInputs = [ llvmPackages.clang ];

    buildInputs = [ ncurses llvmPackages.libclang ];

    LIBCLANG_PATH = "${llvmPackages.libclang}/lib";
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/grin" ];
      User = "1000:1000";
    };
  };
}
