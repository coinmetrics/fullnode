{ nixpkgs, version }:
rec {
  package = with nixpkgs; rustPlatform.buildRustPackage {
    pname = "grin";
    inherit version;

    cargoSha256 = {
      "5.0.4" = "1fxq7ybb5immakjdgsy60y730jjfwj8nd148sw7nphn2m03brjz5";
      "5.1.0" = "12ciinv2136x8vr011v71ixlhixnrwifjfx36kkj1nblrrg0vawd";
      "5.1.1" = "11l46ajihgndqdf906iqmwgmdc535rkby8l1n90w74a0j36vpamz";
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
