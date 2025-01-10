{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-geth";
  version = "1.101411.4";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-pMosMML+tyN/GcmAfKersvjXSQvr/zdrmbr5fKLyPpg=";
  };

  vendorHash = "sha256-NKfbntxifwXct/pcFWOIYtggpirJKepXTklFgnyJnFo=";

  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
