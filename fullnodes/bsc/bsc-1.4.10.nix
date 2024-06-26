{ buildGo121Module, fetchFromGitHub }:
buildGo121Module rec {
  pname = "bsc";
  version = "1.4.10";

  src = fetchFromGitHub {
    owner = "bnb-chain";
    repo = "bsc";
    rev = "refs/tags/v${version}";
    hash = "sha256-Kev08Z9B1QnVAZ69iXMGFV7oL/xSJhSpqvJOT6wzqY8=";
  };

  vendorHash = "sha256-cXYIjNMCIUE2q76P8p3Uj4DUjKeeETJB8hEz86Z3cXg=";
  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
