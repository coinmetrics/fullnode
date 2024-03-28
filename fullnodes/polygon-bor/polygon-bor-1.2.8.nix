{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "polygon-bor";
  version = "1.2.8";

  src = fetchFromGitHub {
    owner = "maticnetwork";
    repo = "bor";
    rev = "v${version}";
    hash = "sha256-HYj7COgmnyfQ1sF/fZinT3NreLLb1rAv4xmV8IbY+x0=";
  };

  vendorHash = "sha256-l25PXNlzodnJU4VDyJ+elN8PokQX/o0EfQGfUEmPsQg=";

  subPackages = [
    "cmd/geth"
  ];

  proxyVendor = true;

  # The tests may require docker
  doCheck = false;

  postInstall = ''
    mv $out/bin/geth $out/bin/bor
  '';
}
