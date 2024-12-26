{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-Ins7Yzrt7MGVOI7AFTj0BIEbz8M9uadLOI8Lm8We7GE=";
  };

  vendorHash = "sha256-wZCUIBgR/7bWtaXTWRMVfFUI/aGAr9TRZfLXme4Q/Sk=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
