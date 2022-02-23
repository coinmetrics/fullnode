{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dcrd";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrd";
    rev = "refs/tags/release-v${version}";
    sha256 = "M4iWefiZ3JlBVOez7j4JjgKpMnCwbk0+QOtkLilJPVU=";
  };

  vendorSha256 = "sha256-SJNgFsLsaPXyyOglGuV610oqX/9poQqW5+Z7QnRtYnU=";
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
