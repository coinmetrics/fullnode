{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "avalanche-rosetta";
  version = "0.1.51";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0UxwErdSkKwTvSsItYc7XTgadDmGnH3/nCx9o0mB8sc=";
  };

  vendorHash = "sha256-+wHMQMv781BeS0g0VPL5UhMp554m0aOGnhWew3/LYQ4=";

  proxyVendor = true;

  postInstall = ''
    mv $out/bin/{server,${pname}}
  '';
}
