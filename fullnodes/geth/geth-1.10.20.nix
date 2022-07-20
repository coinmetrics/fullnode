{ buildGoModule, fetchFromGitHub }:
buildGoModule {
  pname = "geth";
  version = "1.10.20";

  vendorSha256 = "sha256-lq62I+CojAOelH2pX3w+cKBM9IKcoaM4g6CIQyKkNk0=";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "8f2416a89a3def6ec2c749d5afafbf2c9a18e3c8";
    sha256 = "sha256-PIQP08QxGJmla7LKEtnEXmwJxDYh02q4fmRHZsYtthU=";
  };

  proxyVendor = true;
  doCheck = false;
}
