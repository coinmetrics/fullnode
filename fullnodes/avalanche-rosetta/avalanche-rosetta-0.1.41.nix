{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "avalanche-rosetta";
  version = "0.1.41";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NyZVOFcP4XQDZfQG9/4CUJzkJ7S1gvEWbUEpPgPzkVM=";
  };

  vendorHash = "sha256-HBIiIbsxhMzwm3Uv5JCwcM41E4UOygrHJgMkJ3V0Q5w=";

  proxyVendor = true;

  postInstall = ''
    mv $out/bin/{server,${pname}}
  '';
}
