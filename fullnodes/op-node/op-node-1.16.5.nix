{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.16.5";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-YunQeS85bykGaKdLbqW17R+PQNQl0zZmPjgF1ln97Ss=";
  };

  vendorHash = "sha256-aBYmChKgI2PnB8j07uajVdS5IkTVGfxcF6sbXpIkVc8=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
