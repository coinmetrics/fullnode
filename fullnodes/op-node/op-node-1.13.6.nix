{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.13.6";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-bG3Be9mvMZLkicJK9ocavKtqCjzviSeUKvVnfonTyl4=";
  };

  vendorHash = "sha256-une9QlREy4JVpmgtAtK9W0ZllNS5A217E+fMaBki1MI=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
