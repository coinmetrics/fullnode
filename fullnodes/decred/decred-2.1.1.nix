{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "decred";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrd";
    rev = "refs/tags/release-v${version}";
    hash = "sha256-mSq4SRSnZOoCuRKVwmb8Y6+KbaTtg+DLf4YX5oApx0k=";
  };

  vendorHash = "sha256-kzb8qh1j2+TlX+et0RSq5qU1LHSEs3Kaf0nHOnGjdd0=";

  doCheck = false;

  subPackages = [ "." ];

  meta = {
    homepage = "https://decred.org";
    description = "Decred daemon in Go (golang)";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
