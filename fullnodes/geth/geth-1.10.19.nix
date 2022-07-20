{ buildGoModule, fetchFromGitHub }:
buildGoModule {
  pname = "geth";
  version = "1.10.19";

  vendorSha256 = "sha256-YJ/RGVKCEEoCVhsXRbq9vN6R6YqP+qMA0LslmoNh6vA=";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "23bee16208718975f9b9e012949b8d4ee1223108";
    sha256 = "sha256-fMhuE4Oa3uZZkWPAcc9TygCoRZzN7ZSMDTg9HAeOYE4=";
  };

  proxyVendor = true;
  doCheck = false;
}
