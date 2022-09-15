{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.10.25";

  vendorSha256 = "sha256-eR/qu9QAd3+0R3XYP0M17+wXL9dRVDjW0Af9PRchrps=";
  #vendorSha256 = "sha256-0000000000000000000000000000000000000000000=";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "refs/tags/v${version}";
    hash = "sha256-mnf0kMfQEEQMricZJfyF7ZB/2F1dyPBx9iT2v/rGh1U=";
  };

  proxyVendor = true;
  doCheck = false;
}
