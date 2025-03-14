{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dcrd";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrd";
    rev = "refs/tags/release-v${version}";
    hash = "sha256-h121epywii2FgNeScmNGMwmpbWFhfQ+IMIVkSfHbYqE=";
  };

  vendorHash = "sha256-gsoZ871s0YAa50qk8XiD/TUD6lVRLKIEzMPtyUb0qPo=";

  doCheck = false;

  subPackages = [ "." ];

  meta = {
    homepage = "https://decred.org";
    description = "Decred daemon in Go (golang)";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
