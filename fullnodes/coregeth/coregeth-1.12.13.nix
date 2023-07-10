{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "coregeth";
  version = "1.12.13";

  #vendorHash = "sha256-0000000000000000000000000000000000000000000=";
  vendorHash = "sha256-ft722pZD97Ry7naAqnHxps4YwVCXPoAxfdVotcV2pjU=";

  src = fetchFromGitHub {
    owner = "etclabscore";
    repo = "core-geth";
    rev = "refs/tags/v${version}";
    hash = "sha256-MTGGyPY4LvDGZV2n0BInIkVKYktwzsgu2adxIdAVptY=";
  };

  proxyVendor = true;
  doCheck = false;
}
