{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-g3fXupveNR2DI/ooGzU4NCMFQrBgs/mABf43JVsZv7o=";
  };

  vendorHash = "sha256-aSbYkGutlFTnJwGSFjnkkiiAMdZuq49U0MQEN7AEkaQ=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
