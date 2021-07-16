{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dcrd";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrd";
    rev = "refs/tags/release-v${version}";
    sha256 = "1sr2l9kha0sqz268bpf80grkwx4hlx2xrdbjl7c7971lmz0fgbpw";
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
