{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "coregeth";
  version = "1.12.11";

  vendorSha256 = "sha256-mqeMscH+bboQFYIGQpTyBiNvgL7vElbUbtiBEpQGFTk=";
  #vendorSha256 = "sha256-0000000000000000000000000000000000000000000=";

  src = fetchFromGitHub {
    owner = "etclabscore";
    repo = "core-geth";
    rev = "refs/tags/v${version}";
    hash = "sha256-kGpEgx+gTtWiiz+LxQPmMXicssDH0u8VYokHMCk21gY=";
  };

  proxyVendor = true;
  doCheck = false;
}
