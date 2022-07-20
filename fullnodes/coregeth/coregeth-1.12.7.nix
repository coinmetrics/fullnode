{ buildGoModule, fetchFromGitHub }:
buildGoModule {
  pname = "coregeth";
  version = "1.12.7";

  vendorSha256 = "sha256-xvAgMwkO/sVrwk9SCwIXhgttntzmEY6HCi1dM3PJ35Q=";

  src = fetchFromGitHub {
    owner = "etclabscore";
    repo = "core-geth";
    rev = "a374c2e8243a7ce07715b2f6da2022b818a59cb7";
    sha256 = "sha256-ErVz5Z4x49WxrvwiNRZtD5sz+93LgI1IhPh9vB/5840=";
  };

  proxyVendor = true;
  doCheck = false;
}
