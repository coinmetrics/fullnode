{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.11.6";

  vendorSha256 = "sha256-M0+1g3+pF9y4EWX4SwO0ucCPNbK+KiRY0URi5NGOOoE=";
  #vendorSha256 = "sha256-0000000000000000000000000000000000000000000=";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "refs/tags/v${version}";
    hash = "sha256-mZ11xan3MGgaUORbiQczKrXSrxzjvQMhZbpHnEal11Y=";
  };

  proxyVendor = true;
  doCheck = false;
}
