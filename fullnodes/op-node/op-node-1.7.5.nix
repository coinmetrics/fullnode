{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-ResHiLthkrSym9jZ/T+IJvO+RHCjT2zlb4v/vTqrdNo=";
  };

  vendorHash = "sha256-P5Y/xOD05Nt59sQFZ9IOuztx9csidB7RLFUywlSamPc=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
