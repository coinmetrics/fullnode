{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dcrd";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrd";
    rev = "refs/tags/release-v${version}";
    hash = "sha256-0000qwXgJhvfbdElddbb1gGxoygmtVtK6DbiSuMxYew=";
  };

  vendorHash = "sha256-0000fj1+KjQ21Jb/qpIzg2W/grzun2Pz5FV5yIBXoTo=";

  doCheck = false;

  subPackages = [ "." ];

  meta = {
    homepage = "https://decred.org";
    description = "Decred daemon in Go (golang)";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
