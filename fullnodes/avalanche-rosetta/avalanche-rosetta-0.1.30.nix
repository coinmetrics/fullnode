{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "avalanche-rosetta";
  version = "0.1.30";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-R5D1IT8OlAltCTtkc+vx9aF/YQWg3VSnyul3ZdLV3VM=";
  };

  vendorHash = "sha256-Oq5kCcw61PPLxDx2EVGOcyBrmu6vGHWPvnURsKNqiAM=";

  proxyVendor = true;

  postInstall = ''
    mv $out/bin/{server,${pname}}
  '';
}
