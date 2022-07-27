{ buildGoModule, fetchFromGitHub }:
buildGoModule {
  pname = "geth";
  version = "1.10.21";

  vendorSha256 = "sha256-eR/qu9QAd3+0R3XYP0M17+wXL9dRVDjW0Af9PRchrps=";
  #vendorSha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    #rev = "refs/tags/v${version}";
    rev = "refs/tags/v1.10.21";
    sha256 = "sha256-qaM1I3ytMZN+5v/Oj47n3Oc21Jk7DtjfWA/xDprbn/M=";
  };

  proxyVendor = true;
  doCheck = false;
}
