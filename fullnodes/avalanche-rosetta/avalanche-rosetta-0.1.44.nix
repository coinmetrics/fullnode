{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "avalanche-rosetta";
  version = "0.1.44";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3pjKxbJGHrnvPyBsFLX5++XxRJgkapJHAxXBwA9m5tQ=";
  };

  vendorHash = "sha256-GrQeFwEtNCSIKvhNfcdgn47A9NQU3sOuZFmVXZB3Ic8=";

  proxyVendor = true;

  postInstall = ''
    mv $out/bin/{server,${pname}}
  '';
}
