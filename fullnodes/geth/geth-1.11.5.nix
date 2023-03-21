{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.11.5";

  vendorSha256 = "sha256-b+MwXfsbKvkQ6I2kwitUZqqMi/wGz6zTX5yFOxpj7fo=";
  #vendorSha256 = "sha256-0000000000000000000000000000000000000000000=";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "refs/tags/v${version}";
    hash = "sha256-QFqPAWW0L9cSBvnDwJKtwWT2jZFyr+zhYaS+GF/nQ9g=";
  };

  proxyVendor = true;
  doCheck = false;
}
