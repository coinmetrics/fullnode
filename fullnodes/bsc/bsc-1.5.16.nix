{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "bsc";
  version = "1.5.16";

  src = fetchFromGitHub {
    owner = "bnb-chain";
    repo = "bsc";
    rev = "refs/tags/v${version}";
    hash = "sha256-nF0uGJbcd4yHsE9EMtily05ORtMjlLoGVocWatv+v5o=";
  };

  vendorHash = "sha256-zu2mQLWRm2qWeuIidcc0r4U7bZnmgk9Ne0GFBfpnXl0=";
  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
