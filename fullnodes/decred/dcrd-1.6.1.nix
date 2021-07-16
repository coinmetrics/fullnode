{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dcrd";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrd";
    rev = "refs/tags/release-v${version}";
    sha256 = "0agag13iadbqjgg1bd31q7s5c5sh0v70qss6l53b982a4jw7fbg1";
  };

  vendorSha256 = "0sq1azzr6qv517hlcc0jb0fk2zjv715hsm15i722wlby4dx78975";

  doCheck = false;

  subPackages = [ "." ];

  meta = {
    homepage = "https://decred.org";
    description = "Decred daemon in Go (golang)";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
