{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.13.2";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "refs/tags/v${version}";
    hash = "sha256-iWNt2cCrjf8eaEay8zLu0GmnAhwVbzsYAfWBHuNSiDs=";
  };

  #vendorHash = "sha256-0000000000000000000000000000000000000000000=";
  vendorHash = "sha256-EYJDqOJqFMLzGXel5X7E93BnrwymI0t2Y3gMhlo5Nxw=";

  proxyVendor = true;
  doCheck = false;
}
