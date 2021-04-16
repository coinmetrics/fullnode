{ nixpkgs, version }:
rec {
  package = with nixpkgs; rustPlatform.buildRustPackage {
    pname = "openethereum";
    inherit version;

    cargoSha256 = {
      "3.2.3" = "1qgl15sd32s0r4q5xmx7lyp92sc81hd4ddc18ynbxjdxgl7knm4k";
      "3.2.4" = "1gm02pcfll362add8a0dcb0sk0mag8z0q23b87yb6fs870bqvhib";
    }.${version} or lib.fakeSha256;

    src = builtins.fetchGit {
      url = "https://github.com/openethereum/openethereum.git";
      ref = "refs/tags/v${version}";
    };

    LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

    nativeBuildInputs = [
      cmake
      llvmPackages.clang
      llvmPackages.libclang
      pkg-config
    ];

    buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isLinux [ systemd ]
    ++ lib.optionals stdenv.isDarwin [ darwin.Security ];

    cargoBuildFlags = [ "--features final" ];

    doCheck = false;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/openethereum" ];
      User = "1000:1000";
    };

    extraCommands = ''
      mkdir ./bin && \
      ln -s ${nixpkgs.dash}/bin/dash ./bin/sh && \
      ln -s ${nixpkgs.gawk}/bin/awk ./bin/awk && \
      ln -s ${package}/bin/openethereum ./bin/openethereum
    '';
  };
}
