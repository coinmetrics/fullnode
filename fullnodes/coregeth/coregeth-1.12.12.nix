{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "coregeth";
  version = "1.12.12";

  #vendorHash = "sha256-0000000000000000000000000000000000000000000=";
  vendorHash = "sha256-TNv+1pjYOQIkpgFlddJT7T+/z5owtIYK5LMUgyE+oEc=";

  src = fetchFromGitHub {
    owner = "etclabscore";
    repo = "core-geth";
    rev = "refs/tags/v${version}";
    hash = "sha256-97+jAaJfy5lKer2DgMxp1fIKwhdr76RDE8jpUQ7ywXU=";
  };

  proxyVendor = true;
  doCheck = false;
}
