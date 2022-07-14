{ nixpkgs, version }:
rec {
  package = with nixpkgs; rustPlatform.buildRustPackage {
    pname = "grin";
    inherit version;

    cargoSha256 = {
      "5.1.1" = "sha256-v6q7zZBAkcNBsoEiv2Yuo7BWH684GpBcw80+GKUyhIY=";
      "5.1.2" = "sha256-aC693nZapyTwIKlXBUeo/UnFbBVnZv+yBGKl5WMCEcA=";
    }.${version} or lib.fakeSha256;

    src = builtins.fetchGit {
      url = "https://github.com/mimblewimble/grin.git";
      ref = "refs/tags/v${version}";
    };

    nativeBuildInputs = [ llvmPackages_12.clang ];

    buildInputs = [ ncurses ];

    LIBCLANG_PATH = "${llvmPackages_12.libclang.lib}/lib";
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/grin" ];
      User = "1000:1000";
    };
  };
}
