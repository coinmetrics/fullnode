{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "erigon";
  version = "2.42.0";

  vendorSha256 = "sha256-gY47bf/bgDU7biGKlZ5g8ZpNYVC6ryH5krHCNzmu+4Q=";

  src = fetchFromGitHub {
    owner = "ledgerwatch";
    repo = "erigon";
    rev = "refs/tags/v${version}";
    hash = "sha256-BWKnFy1BO6oiTZuD3+9qHT9nFuVS6OHR3/7omoJIMSg=";
  };

  libsecp256k1-src = fetchFromGitHub {
    owner = "ledgerwatch";
    repo = "secp256k1";
    rev = "refs/tags/v1.0.0";
    hash = "sha256-Xp2FZSa+e246I8Pvk/ccc/j9JjgfURqa8nT7T9em7Rk=";
  };

  blst-src = fetchFromGitHub {
    owner = "supranational";
    repo = "blst";
    rev = "refs/tags/v0.3.10";
    hash = "sha256-xero1aTe2v4IhWIJaEDUsVDOfE77dOV5zKeHWntHogY=";
  };

  subPackages = [
    "cmd/erigon"
  ];

  postBuild = ''
    if [[ "$name" == "${pname}-${version}-go-modules" ]]; then
      pushd vendor/github.com/ledgerwatch
      rm -rf secp256k1
      cp -a ${libsecp256k1-src} secp256k1
      popd

      pushd vendor/github.com/supranational
      rm -rf blst
      cp -a ${blst-src} blst
      popd
    fi
  '';
}
