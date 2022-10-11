{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dcrd";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrd";
    rev = "refs/tags/release-v${version}";
    hash = "sha256-9k4xzjACUoyBGPVSE5yWzyX0N9vxn03IPn/LeISKMsg=";
  };

  vendorSha256 = "sha256-2ic1vZbZKiFwbXokZUH1YKZ/OZydx/z5RdJnzqi08FU=";
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
