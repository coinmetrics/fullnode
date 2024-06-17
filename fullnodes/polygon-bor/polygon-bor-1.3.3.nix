{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "polygon-bor";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "maticnetwork";
    repo = "bor";
    rev = "v${version}";
    hash = "sha256-gdBfG7tT4AjHUQuLfrHEbARuT15U1qlFkX5vNrJo7zM=";
  };

  vendorHash = "sha256-osKqRCFojS2Aa16WnTrVawhJfE1bYkEt0AgKXudw+a8=";

  subPackages = [
    "cmd/cli"
  ];

  proxyVendor = true;

  # The tests may require docker
  doCheck = false;

  postInstall = ''
    mv $out/bin/cli $out/bin/bor
  '';
}
