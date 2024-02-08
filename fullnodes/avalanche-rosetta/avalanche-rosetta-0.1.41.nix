{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "avalanche-rosetta";
  version = "0.1.41";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0000000000000000000000000000000000000000000=";
  };

  vendorHash = "sha256-5cj0DTIroS6xdojxbuS/V16Wrkbdv0nKTw7gMWdpQFs=";

  proxyVendor = true;

  postInstall = ''
    mv $out/bin/{server,${pname}}
  '';
}
