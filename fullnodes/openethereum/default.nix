{ nixpkgs, version }:
rec {
  package = with nixpkgs; rustPlatform.buildRustPackage {
    pname = "openethereum";
    inherit version;

    cargoSha256 = {
      "3.2.1" = "163kiy04iw20g8fm2vy7slq2qdmi1a34cgvf7cdsq5y6khky7f49";
      "3.2.3" = "1qgl15sd32s0r4q5xmx7lyp92sc81hd4ddc18ynbxjdxgl7knm4k";
    }.${version} or (builtins.trace "OpenEthereum fullnode: using dummy cargo SHA256" "0000000000000000000000000000000000000000000000000000");

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
