{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "avalanche-rosetta";
  version = "0.1.50";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CJszfAa4a4UoDiMBWTMvBLOhr4tGn0iubqd8gHzxqn0=";
  };

  vendorHash = "sha256-+wHMQMv781BeS0g0VPL5UhMp554m0aOGnhWew3/LYQ4=";

  proxyVendor = true;

  postInstall = ''
    mv $out/bin/{server,${pname}}
  '';
}
