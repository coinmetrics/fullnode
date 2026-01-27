{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "decred";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrd";
    rev = "refs/tags/release-v${version}";
    hash = "sha256-7hlrsKFYENgVn4Se0Wk3qXk9QUM1o4cod9TiIBH4kFQ=";
  };

  vendorHash = "sha256-Rf74x9hK4F2DhgR7QTuXgRJKZ6Kc4WhNw/SPBFEyIvk=";

  doCheck = false;

  subPackages = [ "." ];

  meta = {
    homepage = "https://decred.org";
    description = "Decred daemon in Go (golang)";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
