{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "refs/tags/v${version}";
    hash = "sha256-eEoWuW4edH/2+GkHI/+bHoB4fgWjaPrCTz5ZmP6qzoY=";
  };

  #vendorHash = "sha256-0000000000000000000000000000000000000000000=";
  vendorHash = "sha256-r+9JQjSsQVICB0WDoSlEhZulyiktb/iXp7qJFqfS5iU=";

  proxyVendor = true;
  doCheck = false;
}
