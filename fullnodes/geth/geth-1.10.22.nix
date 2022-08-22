{ buildGoModule, fetchFromGitHub }:
buildGoModule {
  pname = "geth";
  version = "1.10.22";

  vendorSha256 = "sha256-eR/qu9QAd3+0R3XYP0M17+wXL9dRVDjW0Af9PRchrps=";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "671094279e8d27f4b4c3c94bf8b636c26b473976";
    sha256 = "sha256-qaM1I3ytMZN+5v/Oj47n3Oc21Jk7DtjfWA/xDprbn/M=";
  };

  proxyVendor = true;
  doCheck = false;
}
