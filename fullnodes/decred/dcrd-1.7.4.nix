{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dcrd";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrd";
    rev = "refs/tags/release-v${version}";
    sha256 = "sha256-S/TnH2lReEvf1/Y7EVCNLbWhWpZ1ZVjubDSv/xklnTI=";
  };

  vendorSha256 = "sha256-lc7FrPpNqgLt+DuDga1Cey2l4ymUjeO25eXBUOlwB5E=";
  #vendorSha256 = lib.fakeHash;  # only for getting the right value

  doCheck = false;

  subPackages = [ "." ];

  meta = {
    homepage = "https://decred.org";
    description = "Decred daemon in Go (golang)";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
