{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-QYa6hyfC+Awe4u5LsCCgU/GtYOqQsuOV7OgTWWinoFc=";
  };

  vendorHash = "sha256-x+2TL/TAl1xGYUmlGWt/i1XOuCB2R++WMByx7cee+4c=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
