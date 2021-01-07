{ nixpkgs, version }:
rec {
  package = with nixpkgs; rustPlatform.buildRustPackage {
    pname = "grin";
    inherit version;
    cargoSha256 = {
      "3.1.0" = "1kvgiqr8114aq4qxmlkdpvlcn48mdws5j33wk0ik184y0i8zb4gm";
      "3.1.1" = "1z98yd6hr4vz0fcxfrvm7678vdkc7gzafa1ci9lm0vs43m9l6nbp";
      "4.0.0" = "1pw9kc18whb421y3gw6x9q25brh52izbdz3p95jm2jkdkm9j29xn";
      "4.0.1" = "1n9k9jd089m4bmnw8gz5bvz923q2ddddqdn9mhi97lxwnvmq8idi";
      "4.0.2" = "0k2gq8dl5d7sfqybs6r0q27hgm55lh2cfzknkhl0hyg8zl1i6ci4";
      "4.1.0" = "0x79q943v0xw1hlgk1sgx1xkjj6gsyv15jr9q1xagchlk6hwvblg";
      "4.1.1" = "0cny8rbi9mg367x3snh9ckx2r45ykp9x5rl5ipynm74cg2r34chs";
      "5.0.1" = "07i2vsm6d98nwv2mz8nqqns8i594kvz8src0np6qbhs8281w0fq5";
    }.${version} or (builtins.trace "Grin fullnode: using dummy cargo SHA256" "0000000000000000000000000000000000000000000000000000");
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
