{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.12.0";

  vendorHash = "sha256-8EnySIl6M0iHRTBv6H3a8/C088yoMJk26/fpV5p7nYw=";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "refs/tags/v${version}";
    hash = "sha256-u1p9k12tY79kA/2Hu109czQZnurHuDJQf/w7J0c8SuU=";
  };

  proxyVendor = true;
  doCheck = false;
}
