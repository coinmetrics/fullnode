{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dcrd";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrd";
    rev = "refs/tags/release-v${version}";
    sha256 = "8Ikc6h1+ALkwa8252PlNVftl/DSDzDiFjleOVsG/r5E=";
  };

  vendorSha256 = "sha256-+1EYInG9X6lbLYTD9t8GCLZ9Mq850ip9mKiYriDNyEg=";
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
