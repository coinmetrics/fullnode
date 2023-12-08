{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "polygon-bor";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "maticnetwork";
    repo = "bor";
    rev = "v${version}";
    hash = "sha256-0uW2cL6Z2TSHP/6iQ99CNZi+iyNf4UckPVIGmwzuuy4=";
  };

  vendorHash = "sha256-KQiJALOsmYmNCrMwGRkwQQbdzPQcyTTrlUyBuHBT/qc=";

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
