{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "go-opera";
  version = "1.1.1-rc.2";

  src = fetchFromGitHub {
    owner = "Fantom-foundation";
    repo = "go-opera";
    rev = "refs/tags/v${version}";
    hash = "sha256-OoDjbCKUoWsZ6jfzmeCwDyvuo28H9YMXxPTRTJOsBcU=";
  };

  vendorHash = "sha256-Phh1ou59OJkk25PlTBJcizSMIWZBCLO0XPIlVW1/EJM=";

  proxyVendor = true;
  doCheck = false;
}
