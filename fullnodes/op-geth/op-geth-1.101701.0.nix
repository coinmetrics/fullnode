{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-geth";
  version = "1.101701.0";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-oOuzgDS85JLDGhESVlI5VyiruW+05U5FiBl+ya2UqtY=";
  };

  vendorHash = "sha256-/XsYCgcQsP33/k1tDLHiDc/vxKevZJBMQ3jyUdeZ4no=";

  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
