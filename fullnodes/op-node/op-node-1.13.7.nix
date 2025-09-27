{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.13.7";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-IA2BWS6U+WmY7TEYZR9VYnd1XhyZ5BMap9Tc+zMM2Tg=";
  };

  vendorHash = "sha256-mkZPmvHYTjBJbq5clQdSBd/tJy+wnRfPG9lXZcQP2P8=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
