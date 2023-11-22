{ buildGo120Module
, fetchFromGitHub
}:
buildGo120Module rec {
  pname = "erigon";
  version = "2.54.0";

  src = fetchFromGitHub {
    owner = "ledgerwatch";
    repo = "erigon";
    rev = "refs/tags/v${version}";
    hash = "sha256-sBW+hl44fC0Kz9tjRfweLIAVa23eLy6l1n8feaybgjs=";
  };

  vendorHash = "sha256-Ft0poTFbj5LyEaRL2Zw+Kp+lUKAxobAXt4PFWuoOAA0=";

  libsecp256k1-src = fetchFromGitHub {
    owner = "ledgerwatch";
    repo = "secp256k1";
    rev = "refs/tags/v1.0.0";
    hash = "sha256-Xp2FZSa+e246I8Pvk/ccc/j9JjgfURqa8nT7T9em7Rk=";
  };

  blst-src = fetchFromGitHub {
    owner = "supranational";
    repo = "blst";
    rev = "refs/tags/v0.3.11";
    hash = "sha256-oqljy+ZXJAXEB/fJtmB8rlAr4UXM+Z2OkDa20gpILNA=";
  };

  subPackages = [
    "cmd/erigon"
  ];

  modPostBuild = ''
    pushd vendor/github.com/ledgerwatch
    rm -rf secp256k1
    cp -a ${libsecp256k1-src} secp256k1
    popd

    pushd vendor/github.com/supranational
    rm -rf blst
    cp -a ${blst-src} blst
    popd
  '';
}
