{ buildGoModule, fetchFromGitHub }:
buildGoModule {
  pname = "coregeth";
  version = "1.12.8";

  vendorSha256 = "sha256-pOz4Zo6gR1XF8zygXhBXcR+4ip0/QlPg3H7vfew2Knk=";

  src = fetchFromGitHub {
    owner = "etclabscore";
    repo = "core-geth";
    rev = "654bc751dffdecb3670cb3a1d6f1915fb774fc58";
    sha256 = "sha256-HY1cL4hxoAM8eXbd/DtpF80tp0EAsxyYjQ/ZqyVvX68=";
  };

  proxyVendor = true;
  doCheck = false;
}
