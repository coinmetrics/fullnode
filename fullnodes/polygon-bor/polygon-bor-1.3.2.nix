{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "polygon-bor";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "maticnetwork";
    repo = "bor";
    rev = "v${version}";
    hash = "sha256-NBARiimGIe8nIoA8jXfOIuH3Rx4eBU79CqubTIO1Fas=";
  };

  vendorHash = "sha256-FHDWvutAi61NDYj/nAf7JASgtzOQmW03AhwFRjqnjc8=";

  subPackages = [
    "cmd/cli"
  ];

  proxyVendor = true;

  # The tests may require docker
  doCheck = false;

  postInstall = ''
    mv $out/bin/cli $out/bin/bor
  '';
}
