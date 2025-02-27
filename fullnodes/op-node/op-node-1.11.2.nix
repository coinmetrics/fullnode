{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-KKfEwuC8XkBgiHduBE4SBbv9dRbE/iN0GWl5Tv2u8tA=";
  };

  vendorHash = "sha256-8V2m+hWZ1m4Zv+QKXMDJmM7SDo1Lpo5FrnxLpWbGkPw=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
