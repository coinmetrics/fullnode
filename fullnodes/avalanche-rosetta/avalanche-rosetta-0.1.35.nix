{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "avalanche-rosetta";
  version = "0.1.35";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JbsdbBi2m61zj8rIgSDI8kLlHnM97DJLzA9t7I43YWE=";
  };

  vendorHash = "sha256-TOF3XuBew9hYznin97mNdC2iQhdhnxMFP9uv7xOE0zs=";

  proxyVendor = true;

  postInstall = ''
    mv $out/bin/{server,${pname}}
  '';
}
