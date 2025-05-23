{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "bsc";
  version = "1.5.13";

  src = fetchFromGitHub {
    owner = "bnb-chain";
    repo = "bsc";
    rev = "refs/tags/v${version}";
    hash = "sha256-rqtnCZySRVO3i20T5ayi0TgDca4Rib337jCByht/luQ=";
  };

  vendorHash = "sha256-zu2mQLWRm2qWeuIidcc0r4U7bZnmgk9Ne0GFBfpnXl0=";
  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
