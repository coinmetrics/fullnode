{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "coregeth";
  version = "1.12.14";

  #vendorHash = "sha256-0000000000000000000000000000000000000000000=";
  vendorHash = "sha256-MtE+a3XykBZg6IybTwMCwMsBQ1Be7OQQe2Ukp0pjawo=";

  src = fetchFromGitHub {
    owner = "etclabscore";
    repo = "core-geth";
    rev = "refs/tags/v${version}";
    hash = "sha256-pkCphXbHs8vUk7WfB0XUJj13r6j75fn46ncLsCuCDWY=";
  };

  proxyVendor = true;
  doCheck = false;
}
