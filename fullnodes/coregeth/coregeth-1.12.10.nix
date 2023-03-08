{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "coregeth";
  version = "1.12.10";

  vendorSha256 = "sha256-VRLspLXnzrG/mK4SD+ZvfnDIIUrUlQ3E0ktvFZZm204=";
  #vendorSha256 = "sha256-0000000000000000000000000000000000000000000=";

  src = fetchFromGitHub {
    owner = "etclabscore";
    repo = "core-geth";
    rev = "refs/tags/v${version}";
    hash = "sha256-gHgL8v01C/E9Ax5O7MZIaEy8FHRhwSVtNVcB+GOD+Ho=";
  };

  proxyVendor = true;
  doCheck = false;
}
