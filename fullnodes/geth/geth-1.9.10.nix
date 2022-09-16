{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.9.10";

  vendorSha256 = "sha256-j3i9DRt4OXVK0zStctl2Keo9IQUYE9G7pudSLSL3Sa4=";
  #vendorSha256 = "sha256-0000000000000000000000000000000000000000000=";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "refs/tags/v${version}";
    hash = "sha256-lqYkcA11Yznm3d4dqODrdaB+6aRm979NVyufR7J7qF4=";
  };

  proxyVendor = true;
  doCheck = false;
}
