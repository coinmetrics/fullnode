{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.16.6";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-UxpgDtQ6n/iQC4oDPnIlictUmTmUaAKl2RNMGxhYG8Q=";
  };

  vendorHash = "sha256-UYjXfk3HFgklC65H9kKA6SsXzI083nNSzwxFwJfxPDg=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
