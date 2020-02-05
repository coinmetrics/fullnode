{ nixpkgs, version }:
rec {
  package = with nixpkgs; rustPlatform.buildRustPackage {
    pname = "ethereum-parity";
    inherit version;
    cargoSha256 = {
      "2.5.13" = "16nf6y0hyffwdhxn1w4ms4zycs5lkzir8sj6c2lgsabig057hb6z";
      "2.6.8" = "1xqmnirx2r91q5gy1skxl0f79xvaqzimq3l0cj4xvfms7mpdfbg1";
    }.${version};
    src = builtins.fetchGit {
      url = "https://github.com/paritytech/parity-ethereum.git";
      ref = "refs/tags/v${version}";
    };

    nativeBuildInputs = [ cmake ];

    buildInputs = [ systemd ];

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
