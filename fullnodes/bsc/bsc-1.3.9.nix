{ buildGo121Module, fetchFromGitHub }:
buildGo121Module rec {
  pname = "bsc";
  version = "1.3.9";

  src = fetchFromGitHub {
    owner = "bnb-chain";
    repo = "bsc";
    rev = "refs/tags/v${version}";
    hash = "sha256-+NnbMVio3lKZXgT92tJE/UvaUTjrq32Yvf8XNvBvHCE=";
  };

  vendorHash = "sha256-PBWFU78NL4vXcwDKkzpa7QSnOezK5UP4Cd1v7EZN/04=";
  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
