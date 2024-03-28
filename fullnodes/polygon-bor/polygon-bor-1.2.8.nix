{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "polygon-bor";
  version = "1.2.8";

  src = fetchFromGitHub {
    owner = "maticnetwork";
    repo = "bor";
    rev = "v${version}";
    hash = "sha256-DL17AwrxiN58djmI8tqMCk6tikQ30PiemIcBMaNS5MA=";
  };

  vendorHash = "sha256-0000000000000000000000000000000000000000000=";

  subPackages = [
    "cmd/geth"
  ];

  proxyVendor = true;

  # The tests may require docker
  doCheck = false;

  postInstall = ''
    mv $out/bin/geth $out/bin/bor
  '';
}
