{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-dS9oikYXVqFSg4WUQj864oOpuiXAF20yKoKEaycYI5Y=";
  };

  vendorHash = "sha256-/+xTySM3CefA2f6iVIFaySoH8wyEFeHuMGrcl8cxaQo=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
