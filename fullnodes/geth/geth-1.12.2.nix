{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "refs/tags/v${version}";
    hash = "sha256-iCLOrf6/f0f7sD0YjmBtlcOcZRDIp9IZkBadTKj1Qjw=";
  };

  #vendorHash = "sha256-0000000000000000000000000000000000000000000=";
  vendorHash = "sha256-OPNEr8Vn4r79t85b+YCvwVKZVl1KH+Fen9LAvVm7HB8=";

  proxyVendor = true;
  doCheck = false;
}
