{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dcrd";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrd";
    rev = "refs/tags/release-v${version}";
    hash = "sha256-A7gpAwote4G8+40DWBNi2TA7K5HCwybtap92xxVVc9k=";
  };

  vendorHash = "sha256-CxamlHooosmXpDP9doBg+zk3qy3XPjlfYLl0EueC4kI=";

  doCheck = false;

  subPackages = [ "." ];

  meta = {
    homepage = "https://decred.org";
    description = "Decred daemon in Go (golang)";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
