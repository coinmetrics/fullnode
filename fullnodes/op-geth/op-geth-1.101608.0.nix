{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-geth";
  version = "1.101608.0";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-YtTUwQOQrCoNXIB6j7Ihp6oLWNeU+uJSdgw+D2IPnPo=";
  };

  vendorHash = "sha256-XS9Z+dG/8P9CLkgBKWmhPORTWarufufHJ7zKwRhpaao=";

  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
