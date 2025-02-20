{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-geth";
  version = "1.101411.8";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-6RD2Qfm1iIQ7VUJXUgE7/49ttHOyGw4kYYbeFnK+p/A=";
  };

  vendorHash = "sha256-EfgB88UUzGsI2uE1DAElV3d/cGGZEdZ67sZbYiw8pQk=";

  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
