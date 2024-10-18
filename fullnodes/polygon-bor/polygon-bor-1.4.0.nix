{ buildGo122Module, fetchFromGitHub }:
buildGo122Module rec {
  pname = "polygon-bor";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "maticnetwork";
    repo = "bor";
    rev = "v${version}";
    hash = "sha256-lncGIpl1p3VSPcUv40cwM2eb9GIiG/QjSHcG1gon+S8=";
  };

  vendorHash = "sha256-yp/sGhbqMYFtShH32YMViOZCoBP1O0ck/jqwwg3fcfY=";

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
