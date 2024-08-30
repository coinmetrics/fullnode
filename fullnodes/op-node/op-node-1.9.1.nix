{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-T5k+G1VTFVk3kfz42J8z0IdN2fXAUKtb+zUOf+FHn3Q=";
  };

  vendorHash = "sha256-n1uJ/dkEjjsTdmL7TeHU4PKnBhiRrqCNtcGxK70Q0c4=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
