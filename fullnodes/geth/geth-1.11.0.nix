{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.11.0";

  vendorSha256 = "sha256-AVJZEnVGL7Ie9GcXkUpznBzdfZU/AijwZz/EmVJ3Sco=";
  #vendorSha256 = "sha256-0000000000000000000000000000000000000000000=";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "refs/tags/v${version}";
    hash = "sha256-QwgFqXTcFZ2zoqlC3oCEgIghJPQ02FwTMbba/DEohwM=";
  };

  proxyVendor = true;
  doCheck = false;
}
