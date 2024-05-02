{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dcrd";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrd";
    rev = "refs/tags/release-v${version}";
    hash = "sha256-nSocqwXgJhvfbdElddbb1gGxoygmtVtK6DbiSuMxYew=";
  };

  vendorHash = "sha256-Napcfj1+KjQ21Jb/qpIzg2W/grzun2Pz5FV5yIBXoTo=";

  doCheck = false;

  subPackages = [ "." ];

  meta = {
    homepage = "https://decred.org";
    description = "Decred daemon in Go (golang)";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
