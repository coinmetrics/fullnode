{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "avalanche-rosetta";
  version = "0.1.45";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bXhbXXTExvZbhWuWzv3CAXGUwZgm557nD55ry0Ns7pc=";
  };

  vendorHash = "sha256-S46u6Vryo6YwRXLVakq8jWoqoECp6uQGKXPFRunCsi4=";

  proxyVendor = true;

  postInstall = ''
    mv $out/bin/{server,${pname}}
  '';
}
