{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.16.12";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-Bcy0j/mnM0GZFRtX3GpgboYMUB5C0Mc27chPuKyOjHc=";
  };

  vendorHash = "sha256-+6YwbGFez/w9U2giMJRwhC7odbddS+xSWjB0Wy1hO7w=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
