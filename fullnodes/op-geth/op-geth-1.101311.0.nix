{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-geth";
  version = "1.101311.0";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-6wzXSCnSGZ93fAA7FMVCygFmcqAFwQG7U93d3Vls0Zg=";
  };

  vendorHash = "sha256-cWMIqQSEr+MjFF8qJzdhnXxSLNu0/G7RsyfpeBzugxY=";

  subPackages = [
    "cmd/geth"
  ];
}
