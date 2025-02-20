{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-geth";
  version = "1.101500.0";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-Sit8yuyAXI8Zmu6BOrOOjZQW+EuUZzwYmzWwtHHNv9U=";
  };

  vendorHash = "sha256-Fpx4cVUC7Gu1fpiVyRLbEDo6jI3Mx99t0hHImPS5pc0=";

  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
